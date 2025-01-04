import SwiftUI
import SwiftData

@MainActor
final class TryOnItemViewModel: ObservableObject {
    // MARK: - Dependencies
    private var apiClient: FashnAPIClient?
    private var modelContext: ModelContext?
    
    // MARK: - Published Properties
    @Published var userPhoto: UIImage?
    @Published var selectedCategory: WardrobeItemCategory = .top
    @Published var selectedItem: WardrobeItem?
    @Published var garmentPhoto: UIImage?
    @Published private(set) var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showSuccessMessage = false
    
    @Query private var allItems: [WardrobeItem]
    
    // MARK: - Initialization
    init() {}
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func setAPIKey(_ key: String) {
        self.apiClient = FashnAPIClient(apiKey: key)
    }
    
    // MARK: - Computed Properties
    var filteredItems: [WardrobeItem] {
        allItems.filter { $0.category == selectedCategory }
    }
    
    var canTryOn: Bool {
        userPhoto != nil && (selectedItem != nil || garmentPhoto != nil) && selectedCategory.supportsTryOn
    }
    
    // MARK: - Methods
    func tryOnItem() {
        guard let modelImage = userPhoto,
              let apiCategory = selectedCategory.apiCategory,
              let apiClient = apiClient,
              let modelContext = modelContext else {
            showError(message: "Invalid input data or missing configuration")
            return
        }
        
        // Get garment image either from selected item or direct upload
        guard let garmentImage = getGarmentImage() else {
            showError(message: "No garment image available")
            return
        }
        
        Task {
            do {
                isLoading = true
                
                // Submit try-on request
                let predictionId = try await apiClient.submitTryOn(
                    modelImage: modelImage,
                    garmentImage: garmentImage,
                    category: apiCategory
                )
                
                // Create and save initial result
                let result = TryOnResult(
                    id: predictionId,
                    garmentItem: selectedItem
                )
                modelContext.insert(result)
                try modelContext.save()
                
                // Show success message and dismiss
                showSuccessMessage = true
                
                // Continue polling in background
                Task {
                    do {
                        try await pollStatus(for: result)
                    } catch {
                        print("Background polling error: \(error.localizedDescription)")
                    }
                }
                
            } catch {
                showError(message: error.localizedDescription)
            }
            
            isLoading = false
        }
    }
    
    private func getGarmentImage() -> UIImage? {
        if let selectedItem = selectedItem, 
           let garmentURL = selectedItem.imageURL,
           let garmentImage = try? UIImage(contentsOfFile: garmentURL.path) {
            return garmentImage
        }
        return garmentPhoto
    }
    
    private func pollStatus(for result: TryOnResult) async throws {
        guard let apiClient = apiClient,
              let modelContext = modelContext else {
            throw FashnAPIError.invalidResponse
        }
        
        var attempts = 0
        let maxAttempts = 20 // 40 seconds with 2-second delay
        
        while attempts < maxAttempts {
            let response = try await apiClient.checkStatus(id: result.id)
            
            // Update result status
            result.status = response.status.rawValue
            
            if let error = response.error {
                result.error = error
                try modelContext.save()
                throw FashnAPIError.apiError(error)
            }
            
            if response.status == .completed, let imageURL = response.output?.first {
                result.resultImageURL = imageURL
                try modelContext.save()
                return
            }
            
            if response.status == .failed {
                throw FashnAPIError.apiError("Try-on failed")
            }
            
            try await Task.sleep(for: .seconds(2))
            attempts += 1
        }
        
        throw FashnAPIError.requestFailed("Timeout waiting for result")
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
} 
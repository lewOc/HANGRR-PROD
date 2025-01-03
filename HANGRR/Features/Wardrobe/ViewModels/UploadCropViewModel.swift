import SwiftUI
import SwiftData

@MainActor
final class UploadCropViewModel: ObservableObject {
    @Published private(set) var selectedImage: UIImage?
    @Published private(set) var maskedImage: UIImage?
    @Published var showImagePicker = false
    @Published var showNameInput = false
    @Published var itemName = ""
    @Published var isError = false
    @Published var selectedCategory: WardrobeItemCategory = .top
    @Published private(set) var errorMessage: String?
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func setImage(_ image: UIImage?) {
        selectedImage = image
        isError = false
        errorMessage = nil
    }
    
    func setMaskedImage(_ image: UIImage?) {
        maskedImage = image
        isError = false
        errorMessage = nil
    }
    
    func saveItem() async throws {
        do {
            guard let image = maskedImage else {
                throw WardrobeError.imageProcessingFailed("No masked image available")
            }
            
            // Calculate target size while maintaining aspect ratio
            let maxDimension: CGFloat = 2048 // Maximum dimension for large displays
            let aspectRatio = image.size.width / image.size.height
            let targetSize: CGSize
            
            if image.size.width > image.size.height {
                targetSize = CGSize(
                    width: maxDimension,
                    height: maxDimension / aspectRatio
                )
            } else {
                targetSize = CGSize(
                    width: maxDimension * aspectRatio,
                    height: maxDimension
                )
            }
            
            // Create a renderer with the target size
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1.0
            format.preferredRange = .extended
            
            let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
            let resizedImage = renderer.image { context in
                context.cgContext.interpolationQuality = .high
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            }
            
            // Save with maximum quality PNG
            guard let imageData = resizedImage.pngData() else {
                throw WardrobeError.imageProcessingFailed("Failed to create PNG data")
            }
            
            let fileName = UUID().uuidString + ".png"
            let savedFileName = try FileManager.default.saveImage(imageData, withName: fileName)
            
            // Cache the image immediately
            ImageCache.shared.set(resizedImage, forKey: savedFileName)
            
            await MainActor.run {
                // Generate a default name based on category
                let defaultName = "New \(selectedCategory.displayName)"
                
                let item = WardrobeItem(
                    name: defaultName,
                    category: selectedCategory,
                    createdAt: .now,
                    storedImageFileName: savedFileName
                )
                
                modelContext.insert(item)
                print("Saved item with name: \(item.name), fileName: \(savedFileName)")
            }
        } catch {
            await MainActor.run {
                isError = true
                errorMessage = error.localizedDescription
            }
            throw error
        }
    }
}

enum WardrobeError: LocalizedError {
    case imageProcessingFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .imageProcessingFailed(let reason):
            return "Failed to process image: \(reason)"
        }
    }
} 
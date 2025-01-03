import SwiftUI
import SwiftData

@MainActor
final class UploadCropViewModel: ObservableObject {
    @Published private(set) var selectedImage: UIImage?
    @Published private(set) var maskedImage: UIImage?
    @Published var showImagePicker = false
    @Published var showNameInput = false
    @Published var itemName = ""
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func setImage(_ image: UIImage?) {
        selectedImage = image
    }
    
    func setMaskedImage(_ image: UIImage?) {
        maskedImage = image
    }
    
    func saveItem() async throws {
        guard let image = maskedImage,
              let imageData = image.pngData() else {
            throw WardrobeError.imageProcessingFailed
        }
        
        let fileName = UUID().uuidString + ".png"
        let savedFileName = try FileManager.default.saveImage(imageData, withName: fileName)
        
        // Cache the image immediately
        ImageCache.shared.set(image, forKey: savedFileName)
        
        await MainActor.run {
            let item = WardrobeItem(
                name: itemName.isEmpty ? "New Item" : itemName,
                imageFileName: savedFileName,
                createdAt: .now,
                category: .tops
            )
            
            modelContext.insert(item)
            print("Saved item with name: \(item.name), fileName: \(savedFileName)")
        }
    }
}

enum WardrobeError: Error {
    case imageProcessingFailed
} 
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
        
        let item = WardrobeItem(
            name: itemName.isEmpty ? "New Item" : itemName,
            imageFileName: savedFileName
        )
        
        modelContext.insert(item)
        try modelContext.save()
    }
}

enum WardrobeError: Error {
    case imageProcessingFailed
} 
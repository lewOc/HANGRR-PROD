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
    @Published var selectedCategory: WardrobeItemCategory = .tops
    
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
        guard let image = maskedImage else {
            throw WardrobeError.imageProcessingFailed
        }
        
        // Calculate target size while maintaining aspect ratio
        let maxDimension: CGFloat = 2048 // Maximum dimension for large displays
        let aspectRatio = image.size.width / image.size.height
        let targetSize: CGSize
        
        if image.size.width > image.size.height {
            let width = min(image.size.width, maxDimension)
            targetSize = CGSize(width: width, height: width / aspectRatio)
        } else {
            let height = min(image.size.height, maxDimension)
            targetSize = CGSize(width: height * aspectRatio, height: height)
        }
        
        // Create high quality renderer with transparency
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0 // Use original scale for maximum quality
        format.opaque = false
        format.preferredRange = .extended // Use extended color range
        
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let resizedImage = renderer.image { context in
            // Enable high-quality rendering
            context.cgContext.setAllowsAntialiasing(true)
            context.cgContext.setShouldAntialias(true)
            context.cgContext.setAllowsFontSmoothing(true)
            context.cgContext.setShouldSmoothFonts(true)
            context.cgContext.interpolationQuality = .high
            
            // Draw with high quality
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        // Save with maximum quality PNG
        guard let imageData = resizedImage.pngData() else {
            throw WardrobeError.imageProcessingFailed
        }
        
        let fileName = UUID().uuidString + ".png"
        let savedFileName = try FileManager.default.saveImage(imageData, withName: fileName)
        
        // Cache the image immediately
        ImageCache.shared.set(resizedImage, forKey: savedFileName)
        
        await MainActor.run {
            let item = WardrobeItem(
                name: itemName.isEmpty ? "New Item" : itemName,
                category: selectedCategory,
                createdAt: .now,
                storedImageFileName: savedFileName
            )
            
            modelContext.insert(item)
            print("Saved item with name: \(item.name), fileName: \(savedFileName)")
        }
    }
}

enum WardrobeError: Error {
    case imageProcessingFailed
} 
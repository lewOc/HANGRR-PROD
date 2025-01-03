import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        // Request highest quality
        if #available(iOS 16.0, *) {
            config.preferredAssetRepresentationMode = .current
        } else {
            config.preferredAssetRepresentationMode = .compatible
        }
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            // Try to load the full size image
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let error = error {
                        print("Error loading image: \(error)")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            // Ensure we maintain the original image size and quality
                            if let cgImage = image.cgImage {
                                let originalImage = UIImage(
                                    cgImage: cgImage,
                                    scale: 1.0,
                                    orientation: image.imageOrientation
                                )
                                self?.parent.image = originalImage
                            } else {
                                self?.parent.image = image
                            }
                        }
                    }
                }
            }
        }
    }
} 
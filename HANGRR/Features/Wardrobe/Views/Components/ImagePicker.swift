import SwiftUI
import PhotosUI

/// A SwiftUI view that presents a photo picker interface for selecting images
/// from the user's photo library.
struct ImagePicker: UIViewControllerRepresentable {
    // MARK: - Properties
    @Binding var image: UIImage?
    @Binding var isError: Bool
    
    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else {
                parent.isError = true
                return
            }
            
            guard provider.canLoadObject(ofClass: UIImage.self) else {
                parent.isError = true
                return
            }
            
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.parent.isError = true
                        print("Error loading image: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let image = image as? UIImage,
                          let cgImage = image.cgImage else {
                        self?.parent.isError = true
                        return
                    }
                    
                    self?.parent.image = UIImage(
                        cgImage: cgImage,
                        scale: 1.0,
                        orientation: image.imageOrientation
                    )
                    self?.parent.isError = false
                }
            }
        }
    }
}

// MARK: - Preview Provider
#Preview {
    struct PreviewWrapper: View {
        @State private var image: UIImage?
        @State private var isError = false
        
        var body: some View {
            ImagePicker(image: $image, isError: $isError)
        }
    }
    
    return PreviewWrapper()
} 
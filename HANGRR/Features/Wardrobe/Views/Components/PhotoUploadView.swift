import SwiftUI
import PhotosUI

struct PhotoUploadView: View {
    @Binding var image: UIImage?
    @State private var showImagePicker = false
    @State private var isError = false
    
    var body: some View {
        Button {
            showImagePicker = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.customPink.opacity(0.3), lineWidth: 1)
                    .background(Color.customLightPink.opacity(0.3))
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    VStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.customPink.opacity(0.3))
                        Text("Tap to upload a photo")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 200)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image, isError: $isError)
        }
        .alert("Error", isPresented: $isError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Failed to load the selected image. Please try again.")
        }
    }
}

#Preview {
    PhotoUploadView(image: .constant(nil))
} 
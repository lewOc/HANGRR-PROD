import SwiftUI

struct PhotoUploadView: View {
    @Binding var image: UIImage?
    
    var body: some View {
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
                    Text("Upload a photo")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(height: 200)
    }
}

#Preview {
    PhotoUploadView(image: .constant(nil))
} 
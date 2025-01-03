import SwiftUI

struct AsyncWardrobeImage: View {
    let imageFileName: String
    let size: CGFloat
    
    @State private var imageLoadError = false
    
    var body: some View {
        Group {
            if let cachedImage = ImageCache.shared.get(forKey: imageFileName) {
                Image(uiImage: cachedImage)
                    .resizable()
                    .scaledToFill()
                    .transition(.opacity)
            } else {
                AsyncImage(
                    url: FileManager.default.documentsDirectory.appendingPathComponent(imageFileName),
                    transaction: Transaction(animation: .easeInOut)
                ) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: size, height: size)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .onAppear {
                                if let uiImage = image.asUIImage() {
                                    Task {
                                        // Cache on background thread
                                        await MainActor.run {
                                            ImageCache.shared.set(uiImage, forKey: imageFileName)
                                        }
                                    }
                                }
                            }
                            .transition(.opacity)
                    case .failure:
                        placeholderView
                            .onAppear { imageLoadError = true }
                    @unknown default:
                        placeholderView
                    }
                }
            }
        }
        .frame(width: size, height: size)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .animation(.easeInOut, value: imageLoadError)
    }
    
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.customLightPink)
            .overlay {
                Image(systemName: "tshirt")
                    .foregroundColor(.customPink)
                    .font(.system(size: size * 0.3))
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        AsyncWardrobeImage(imageFileName: "test.png", size: 100)
        AsyncWardrobeImage(imageFileName: "nonexistent.png", size: 100)
    }
    .padding()
} 
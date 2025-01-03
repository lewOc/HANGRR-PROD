import SwiftUI

struct UploadCropView: View {
    @StateObject private var viewModel = UploadCropViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                // Drawing area
                ZStack {
                    Color(.systemBackground)
                    
                    // T-shirt icon
                    Image(systemName: "tshirt")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.brandPink)
                    
                    // TODO: Add drawing canvas here
                }
                
                // Instructions
                VStack(spacing: 8) {
                    Text("Draw around your garment")
                        .font(.headline)
                    
                    Text("Trace the outline of the item you want to add to your wardrobe. Make sure to complete the shape by connecting back to the start.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                
                // Reset button
                Button(action: {
                    viewModel.resetDrawing()
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.brandPink)
                    .cornerRadius(8)
                }
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.handleDone()
                    }
                }
            }
            .navigationTitle("Crop Garment")
        }
    }
}

// MARK: - Preview
struct UploadCropView_Previews: PreviewProvider {
    static var previews: some View {
        UploadCropView()
    }
}

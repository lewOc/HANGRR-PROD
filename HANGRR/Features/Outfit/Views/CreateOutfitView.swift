import SwiftUI
import SwiftData

struct CreateOutfitView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CreateOutfitViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Photo Upload Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Photo")
                    .font(.headline)
                
                PhotoUploadView(image: $viewModel.userPhoto)
            }
            
            // Top Selection Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Select Top")
                        .font(.headline)
                    Spacer()
                    Button("Browse Wardrobe") {
                        viewModel.browseTops()
                    }
                    .foregroundColor(.customPink)
                }
                
                HorizontalWardrobeItemsGrid(items: viewModel.topItems, selectedItem: $viewModel.selectedTop)
            }
            
            // Bottom Selection Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Select Bottom")
                        .font(.headline)
                    Spacer()
                    Button("Browse Wardrobe") {
                        viewModel.browseBottoms()
                    }
                    .foregroundColor(.customPink)
                }
                
                HorizontalWardrobeItemsGrid(items: viewModel.bottomItems, selectedItem: $viewModel.selectedBottom)
            }
            
            Spacer()
            
            // Try On Button
            Button {
                viewModel.tryOnOutfit()
            } label: {
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "tshirt")
                        Text("Try On Outfit")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customLightPink)
                    .foregroundColor(.customPink)
                    .cornerRadius(10)
                    
                    Text("Use AI to virtually try on this outfit combination")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .disabled(!viewModel.canTryOn)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Create Outfit")
                    .font(.headline)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateOutfitView()
    }
} 
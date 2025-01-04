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
                    .foregroundColor(.pink)
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
                    .foregroundColor(.pink)
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
                    .background(Color.pink.opacity(0.2))
                    .foregroundColor(.pink)
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

// MARK: - Supporting Views
private struct PhotoUploadView: View {
    @Binding var image: UIImage?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.pink.opacity(0.3), lineWidth: 1)
                .background(Color.pink.opacity(0.05))
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.pink.opacity(0.3))
                    Text("Upload a photo")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(height: 200)
    }
}

private struct HorizontalWardrobeItemsGrid: View {
    let items: [WardrobeItem]
    @Binding var selectedItem: WardrobeItem?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())], spacing: 12) {
                ForEach(items) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        WardrobeItemView(item: item)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedItem?.id == item.id ? Color.pink : Color.clear, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(height: 100)
        }
    }
}

#Preview {
    NavigationStack {
        CreateOutfitView()
    }
} 
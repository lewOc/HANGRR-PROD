import SwiftUI
import SwiftData

private struct GridConstants {
    static let spacing: CGFloat = 16
    static let threeColumn = Array(repeating: GridItem(.flexible(), spacing: spacing), count: 3)
}

struct WardrobeView: View {
    @StateObject private var viewModel = WardrobeViewModel()
    @Query(sort: \WardrobeItem.createdAt, order: .reverse) private var wardrobeItems: [WardrobeItem]
    @Environment(\.modelContext) private var modelContext
    @State private var path = NavigationPath()
    
    init() {
        let sortDescriptor = SortDescriptor<WardrobeItem>(\.createdAt, order: .reverse)
        _wardrobeItems = Query(sort: [sortDescriptor])
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Custom header
                    HStack {
                        Text("Wardrobe")
                            .font(.system(size: 34, weight: .bold))
                        
                        Spacer()
                        
                        NavigationLink(destination: EmptyView()) {
                            Image(systemName: "person.circle")
                                .imageScale(.large)
                                .foregroundColor(.customPink)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Try On Buttons
                    HStack(spacing: 16) {
                        TryOnButton(
                            icon: "tshirt",
                            title: "Try On Outfit",
                            action: viewModel.navigateToTryOnOutfit
                        )
                        
                        TryOnButton(
                            icon: "person.crop.rectangle",
                            title: "Try On Item",
                            action: viewModel.navigateToTryOnItem
                        )
                    }
                    .padding(.horizontal)
                    
                    // Wardrobe Items Section
                    NavigationLink(destination: WardrobeItemsView()) {
                        SectionHeader(
                            title: "Wardrobe Items",
                            subtitle: "These are all of your wardrobe items"
                        ) {
                            AnyView(
                                Button {
                                    path.append("upload")
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.customPink)
                                        .clipShape(Circle())
                                }
                            )
                        }
                    }
                    .foregroundColor(.primary)
                    
                    // Wardrobe Grid
                    if !wardrobeItems.isEmpty {
                        WardrobeItemsGrid(items: Array(wardrobeItems.prefix(6)))
                    } else {
                        // Empty State
                        VStack(spacing: 12) {
                            Image(systemName: "tshirt")
                                .font(.system(size: 40))
                                .foregroundColor(.customPink)
                            Text("No items yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                    
                    // Try On Results Section
                    NavigationLink(destination: EmptyView()) {
                        SectionHeader(
                            title: "Try On Results",
                            subtitle: "View your virtual try-on history"
                        )
                    }
                    .foregroundColor(.primary)
                    
                    // Results Grid
                    TryOnResultsGrid()
                    
                    // Outfits Section
                    NavigationLink(destination: EmptyView()) {
                        SectionHeader(
                            title: "Outfits",
                            subtitle: "Click an outfit to add accessories"
                        )
                    }
                    .foregroundColor(.primary)
                    
                    // Outfits Grid
                    OutfitsGrid()
                }
                .padding(.vertical)
            }
            .navigationDestination(for: String.self) { route in
                if route == "upload" {
                    UploadCropView(modelContext: modelContext)
                }
            }
        }
    }
}

// MARK: - Supporting Views
private struct TryOnButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.customPink)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}

private struct SectionHeader: View {
    let title: String
    let subtitle: String
    var actionButton: (() -> AnyView)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.title2)
                    .bold()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .imageScale(.small)
                
                Spacer()
                
                if let actionButton {
                    actionButton()
                }
            }
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

private struct WardrobeItemsGrid: View {
    let items: [WardrobeItem]
    
    var body: some View {
        LazyVGrid(columns: GridConstants.threeColumn, spacing: GridConstants.spacing) {
            ForEach(items.prefix(6)) { item in
                NavigationLink(destination: WardrobeItemsView()) {
                    if let imageFileName = item.storedImageFileName {
                        if let cachedImage = ImageCache.shared.get(forKey: imageFileName) {
                            Image(uiImage: cachedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 3)
                        } else if let imageURL = item.imageURL {
                            AsyncImage(url: imageURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 3)
                                        .onAppear {
                                            if let uiImage = image.asUIImage() {
                                                ImageCache.shared.set(uiImage, forKey: imageFileName)
                                            }
                                        }
                                case .failure:
                                    EmptyView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 100, height: 100)
                        }
                    }
                }
            }
            
            // Only show "Add Item" button if we have less than 6 items
            if items.count < 6 {
                NavigationLink(value: "upload") {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.customPink)
                        Text("Add Item")
                            .font(.caption)
                            .foregroundColor(.customPink)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.customLightPink.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(.horizontal)
    }
}

private struct TryOnResultsGrid: View {
    var body: some View {
        LazyVGrid(columns: GridConstants.threeColumn, spacing: GridConstants.spacing) {
            ForEach(0..<3) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.customLightPink)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        VStack {
                            Image(systemName: "person.crop.rectangle")
                                .foregroundColor(.customPink)
                            Text("Try On an Item")
                                .font(.caption)
                                .foregroundColor(.customPink)
                        }
                    }
            }
        }
        .padding(.horizontal)
    }
}

private struct OutfitsGrid: View {
    var body: some View {
        LazyVGrid(columns: GridConstants.threeColumn, spacing: GridConstants.spacing) {
            ForEach(0..<3) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.customLightPink)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        VStack {
                            Image(systemName: "tshirt.fill")
                                .foregroundColor(.customPink)
                            Text("Add Outfit")
                                .font(.caption)
                                .foregroundColor(.customPink)
                        }
                    }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview
#Preview {
    WardrobeView()
        .modelContainer(ModelContainerFactory.preview)
} 

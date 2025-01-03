import SwiftUI

// MARK: - Constants
private enum Layout {
    static let spacing: CGFloat = 16
    static let gridColumns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: 3)
    static let itemSize: CGFloat = 100
    static let iconSize: CGFloat = 30
}

// MARK: - Wardrobe Items Grid
struct WardrobeItemsGrid: View {
    let items: [WardrobeItem]
    @Binding var path: NavigationPath
    
    var body: some View {
        LazyVGrid(columns: Layout.gridColumns, spacing: Layout.spacing) {
            ForEach(0..<6) { index in
                if index < items.count {
                    NavigationLink(destination: WardrobeItemsView()) {
                        WardrobeItemView(item: items[index])
                    }
                } else {
                    placeholderItem
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var placeholderItem: some View {
        NavigationLink(value: "upload") {
            VStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: Layout.iconSize))
                    .foregroundColor(.customPink)
                Text("Add Item")
                    .font(.caption)
                    .foregroundColor(.customPink)
            }
            .frame(width: Layout.itemSize, height: Layout.itemSize)
            .background(Color.customLightPink.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Try On Results Grid
struct TryOnResultsGrid: View {
    var body: some View {
        LazyVGrid(columns: Layout.gridColumns, spacing: Layout.spacing) {
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

// MARK: - Outfits Grid
struct OutfitsGrid: View {
    var body: some View {
        LazyVGrid(columns: Layout.gridColumns, spacing: Layout.spacing) {
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

// MARK: - Wardrobe Item View
private struct WardrobeItemView: View {
    let item: WardrobeItem
    
    var body: some View {
        if let imageFileName = item.storedImageFileName {
            AsyncWardrobeImage(imageFileName: imageFileName, size: Layout.itemSize)
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.customLightPink)
                .frame(width: Layout.itemSize, height: Layout.itemSize)
                .overlay {
                    Image(systemName: "tshirt")
                        .foregroundColor(.customPink)
                        .font(.system(size: Layout.itemSize * 0.3))
                }
        }
    }
}

// MARK: - Preview Provider
#Preview {
    WardrobeItemsGrid(items: [], path: .constant(NavigationPath()))
        .previewLayout(.sizeThatFits)
} 
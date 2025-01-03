import SwiftUI
import SwiftData

struct WardrobeItemsView: View {
    @StateObject private var viewModel = WardrobeItemsViewModel()
    @Query(sort: \WardrobeItem.createdAt, order: .reverse) private var allItems: [WardrobeItem]
    @Environment(\.modelContext) private var modelContext
    
    init() {
        let sortDescriptor = SortDescriptor<WardrobeItem>(\.createdAt, order: .reverse)
        _allItems = Query(sort: [sortDescriptor])
    }
    
    // MARK: - Properties
    private struct GridConstants {
        static let spacing: CGFloat = 12
        static let threeColumn = Array(repeating: GridItem(.flexible(), spacing: spacing), count: 3)
    }
    
    private var filteredItems: [WardrobeItem] {
        switch viewModel.selectedCategory {
        case .all:
            return allItems
        case .category(let itemCategory):
            return allItems.filter { $0.category == itemCategory }
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            // Categories ScrollView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(WardrobeCategory.allCases, id: \.self) { category in
                        CategoryButton(
                            title: category.title,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            viewModel.selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Items count and sort
            HStack {
                Text("\(filteredItems.count) items")
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button {
                    viewModel.showSortOptions = true
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
            }
            .padding(.horizontal)
            
            // Items Grid
            ScrollView {
                LazyVGrid(columns: GridConstants.threeColumn, spacing: GridConstants.spacing) {
                    ForEach(filteredItems) { item in
                        WardrobeItemCard(item: item)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Supporting Views
private struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(isSelected ? Color.customPink : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

private struct WardrobeItemCard: View {
    let item: WardrobeItem
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if let imageURL = item.imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 2)
                    case .failure(_):
                        placeholderView
                    @unknown default:
                        placeholderView
                    }
                }
                .frame(width: 110, height: 110)
            } else {
                placeholderView
            }
            
            Text(item.name)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
    
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.customLightPink)
            .frame(width: 110, height: 110)
            .overlay {
                Image(systemName: "tshirt")
                    .foregroundColor(.customPink)
                    .font(.system(size: 30))
            }
    }
}

// Helper view to maintain square aspect ratio
private struct SquareImageContainer<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            content()
                .frame(width: size, height: size)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height: 200)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        WardrobeItemsView()
            .modelContainer(for: WardrobeItem.self)
    }
} 
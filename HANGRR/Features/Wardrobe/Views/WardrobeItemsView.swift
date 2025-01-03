import SwiftUI
import SwiftData

struct WardrobeItemsView: View {
    @StateObject private var viewModel = WardrobeItemsViewModel()
    @Query private var items: [WardrobeItem]
    
    // MARK: - Properties
    private struct GridConstants {
        static let spacing: CGFloat = 16
        static let twoColumn = Array(repeating: GridItem(.flexible(), spacing: spacing), count: 2)
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
                Text("\(items.count) items")
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
                LazyVGrid(columns: GridConstants.twoColumn, spacing: GridConstants.spacing) {
                    ForEach(items) { item in
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
            SquareImageContainer {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.customLightPink)
                    .overlay {
                        if let imageURL = item.imageURL {
                            AsyncImage(url: imageURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(8)
                                case .failure(_):
                                    Image(systemName: "tshirt")
                                        .foregroundColor(.customPink)
                                @unknown default:
                                    Image(systemName: "tshirt")
                                        .foregroundColor(.customPink)
                                }
                            }
                        } else {
                            Image(systemName: "tshirt")
                                .foregroundColor(.customPink)
                        }
                    }
            }
            
            Text(item.name)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
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
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        WardrobeItemsView()
            .modelContainer(for: WardrobeItem.self, inMemory: true)
    }
} 
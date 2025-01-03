import SwiftUI
import SwiftData

struct WardrobeItemsView: View {
    @StateObject private var viewModel = WardrobeItemsViewModel()
    @Query private var items: [WardrobeItem]
    
    // MARK: - Properties
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
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
                LazyVGrid(columns: columns, spacing: 16) {
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
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.customLightPink)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let imageURL = item.imageURL {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "tshirt")
                            .foregroundColor(.customPink)
                    }
                }
            
            Text(item.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        WardrobeItemsView()
            .modelContainer(for: WardrobeItem.self, inMemory: true)
    }
} 
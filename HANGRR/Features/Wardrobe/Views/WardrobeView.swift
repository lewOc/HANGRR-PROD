import SwiftUI
import SwiftData

// MARK: - Constants
private enum Layout {
    static let spacing: CGFloat = 16
    static let gridColumns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: 3)
    static let headerFontSize: CGFloat = 34
    static let iconSize: CGFloat = 40
    static let itemSize: CGFloat = 150
}

/// The main view for displaying the user's wardrobe items, try-on results, and outfits
struct WardrobeView: View {
    // MARK: - Properties
    @StateObject private var viewModel = WardrobeViewModel()
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\WardrobeItem.createdAt, order: .reverse)]) private var wardrobeItems: [WardrobeItem]
    
    // MARK: - Initialization
    init(sortOrder: SortDescriptor<WardrobeItem> = SortDescriptor(\WardrobeItem.createdAt, order: .reverse)) {
        _wardrobeItems = Query(sort: [sortOrder])
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    tryOnButtonsSection
                    wardrobeItemsSection
                    tryOnResultsSection
                    outfitsSection
                }
                .padding(.vertical)
            }
            .navigationDestination(for: String.self) { route in
                switch route {
                case "upload":
                    UploadCropView(modelContext: modelContext)
                case "tryOnOutfit":
                    CreateOutfitView()
                case "tryOnItem":
                    TryOnItemView()
                default:
                    EmptyView()
                }
            }
        }
    }
    
    // MARK: - View Components
    private var headerSection: some View {
        HStack {
            Text("Wardrobe")
                .font(.system(size: Layout.headerFontSize, weight: .bold))
            
            Spacer()
            
            NavigationLink(destination: EmptyView()) {
                Image(systemName: "person.circle")
                    .imageScale(.large)
                    .foregroundColor(.customPink)
            }
        }
        .padding(.horizontal)
    }
    
    private var tryOnButtonsSection: some View {
        HStack(spacing: Layout.spacing) {
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
    }
    
    private var wardrobeItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink(destination: WardrobeItemsView()) {
                SectionHeader(
                    title: "Wardrobe Items",
                    subtitle: "These are all of your wardrobe items"
                ) {
                    AnyView(
                        Button {
                            viewModel.navigationPath.append("upload")
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
            
            WardrobeItemsGrid(items: Array(wardrobeItems.prefix(6)))
        }
    }
    
    private var tryOnResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink(destination: EmptyView()) {
                SectionHeader(
                    title: "Try On Results",
                    subtitle: "View your virtual try-on history"
                )
            }
            .foregroundColor(.primary)
            
            TryOnResultsGrid()
        }
    }
    
    private var outfitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink(destination: EmptyView()) {
                SectionHeader(
                    title: "Outfits",
                    subtitle: "Click an outfit to add accessories"
                )
            }
            .foregroundColor(.primary)
            
            OutfitsGrid()
        }
    }
}

// MARK: - Supporting Views
private struct EmptyStateView: View {
    let icon: String
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: Layout.iconSize))
                .foregroundColor(.customPink)
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Preview Provider

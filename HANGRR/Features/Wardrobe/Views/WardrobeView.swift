import SwiftUI
import SwiftData

private struct GridConstants {
    static let spacing: CGFloat = 16
    static let threeColumn = Array(repeating: GridItem(.flexible(), spacing: spacing), count: 3)
}

struct WardrobeView: View {
    @StateObject private var viewModel = WardrobeViewModel()
    @Query private var wardrobeItems: [WardrobeItem]
    @Environment(\.modelContext) private var modelContext
    @State private var showingUploadView = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
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
                                    showingUploadView = true
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.customPink)
                                        .clipShape(Circle())
                                }
                                .navigationDestination(isPresented: $showingUploadView) {
                                    UploadCropView(modelContext: modelContext)
                                }
                            )
                        }
                    }
                    .foregroundColor(.primary)
                    
                    // Wardrobe Grid
                    WardrobeItemsGrid(items: wardrobeItems)
                    
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
            if items.isEmpty {
                // Show 6 placeholder items when no items exist
                ForEach(0..<6) { _ in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.customLightPink)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            Image(systemName: "tshirt")
                                .foregroundColor(.customPink)
                        }
                }
            } else {
                ForEach(items) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.customLightPink)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            Image(systemName: "tshirt")
                                .foregroundColor(.customPink)
                        }
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
        .modelContainer(for: WardrobeItem.self, inMemory: true)
} 

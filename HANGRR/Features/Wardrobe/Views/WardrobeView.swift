import SwiftUI
import SwiftData

struct WardrobeView: View {
    @StateObject private var viewModel = WardrobeViewModel()
    @Query private var wardrobeItems: [WardrobeItem]
    
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
                        )
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
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
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
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
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
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
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
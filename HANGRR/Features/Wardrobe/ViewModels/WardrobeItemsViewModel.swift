import Foundation

@MainActor
final class WardrobeItemsViewModel: ObservableObject {
    @Published var selectedCategory: WardrobeCategory = .all
    @Published var showSortOptions = false
    
    // Add more functionality as needed
} 
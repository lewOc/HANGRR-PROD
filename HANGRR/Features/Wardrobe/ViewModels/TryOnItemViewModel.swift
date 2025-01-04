import SwiftUI
import SwiftData

@MainActor
final class TryOnItemViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var userPhoto: UIImage?
    @Published var selectedCategory: WardrobeItemCategory = .top
    @Published var selectedItem: WardrobeItem?
    @Published private(set) var isLoading = false
    
    @Query private var allItems: [WardrobeItem]
    
    // MARK: - Computed Properties
    var filteredItems: [WardrobeItem] {
        allItems.filter { $0.category == selectedCategory }
    }
    
    var canTryOn: Bool {
        userPhoto != nil && selectedItem != nil
    }
    
    // MARK: - Methods
    func tryOnItem() {
        // TODO: Implement try-on functionality using Fashn AI
    }
} 
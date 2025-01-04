import SwiftUI
import SwiftData

@MainActor
final class CreateOutfitViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var userPhoto: UIImage?
    @Published var selectedTop: WardrobeItem?
    @Published var selectedBottom: WardrobeItem?
    @Published var topItems: [WardrobeItem] = []
    @Published var bottomItems: [WardrobeItem] = []
    @Published private(set) var isLoading = false
    
    // MARK: - Computed Properties
    var canTryOn: Bool {
        userPhoto != nil && selectedTop != nil && selectedBottom != nil
    }
    
    // MARK: - Methods
    func browseTops() {
        // TODO: Implement wardrobe browsing for tops
    }
    
    func browseBottoms() {
        // TODO: Implement wardrobe browsing for bottoms
    }
    
    func tryOnOutfit() {
        // TODO: Implement try-on functionality using Fashn AI
    }
} 
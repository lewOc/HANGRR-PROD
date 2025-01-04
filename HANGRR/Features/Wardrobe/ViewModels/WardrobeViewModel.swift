import Foundation
import SwiftData
import SwiftUI

@MainActor
final class WardrobeViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isAddingItem = false
    @Published var navigationPath: NavigationPath = NavigationPath()
    
    // MARK: - Navigation
    func navigateToTryOnOutfit() {
        // TODO: Implement navigation
    }
    
    func navigateToTryOnItem() {
        navigationPath.append("tryOnItem")
    }
    
    func navigateToWardrobeItems() {
        // TODO: Implement navigation
    }
    
    func navigateToTryOnResults() {
        // TODO: Implement navigation
    }
} 
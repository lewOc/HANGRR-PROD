import Foundation

// For UI filtering
enum WardrobeCategory: CaseIterable, Equatable, Hashable {
    case all
    case category(WardrobeItemCategory)
    
    var title: String {
        switch self {
        case .all: return "All"
        case .category(let category): return category.displayName
        }
    }
    
    static var allCases: [WardrobeCategory] {
        [.all] + WardrobeItemCategory.allCases.map(WardrobeCategory.category)
    }
} 
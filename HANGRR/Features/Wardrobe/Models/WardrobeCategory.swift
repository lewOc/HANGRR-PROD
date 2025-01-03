import Foundation

// For storage in SwiftData
enum WardrobeItemCategory: String, Codable, CaseIterable, Hashable {
    case tops
    case bottoms
    case dresses
    case shoes
    
    var title: String {
        switch self {
        case .tops: return "Tops"
        case .bottoms: return "Bottoms"
        case .dresses: return "Dresses"
        case .shoes: return "Shoes"
        }
    }
}

// For UI filtering
enum WardrobeCategory: CaseIterable, Equatable, Hashable {
    case all
    case category(WardrobeItemCategory)
    
    var title: String {
        switch self {
        case .all: return "All"
        case .category(let category): return category.title
        }
    }
    
    static var allCases: [WardrobeCategory] {
        [.all] + WardrobeItemCategory.allCases.map(WardrobeCategory.category)
    }
} 
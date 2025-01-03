import Foundation

enum WardrobeCategory: CaseIterable {
    case all
    case tops
    case bottoms
    case dresses
    case shoes
    
    var title: String {
        switch self {
        case .all: return "All"
        case .tops: return "Tops"
        case .bottoms: return "Bottoms"
        case .dresses: return "Dresses"
        case .shoes: return "Shoes"
        }
    }
} 
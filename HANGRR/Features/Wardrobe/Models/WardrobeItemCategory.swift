import Foundation

/// Categories for wardrobe items
public enum WardrobeItemCategory: String, Codable, CaseIterable, Hashable {
    case top = "Top"
    case bottom = "Bottom"
    case onePiece = "One-Piece"
    case accessory = "Accessory"
    case shoes = "Shoes"
    
    var displayName: String {
        rawValue
    }
    
    var apiCategory: String? {
        switch self {
        case .top:
            return "tops"
        case .bottom:
            return "bottoms"
        case .onePiece:
            return "one-pieces"
        case .accessory, .shoes:
            return nil
        }
    }
    
    var supportsTryOn: Bool {
        apiCategory != nil
    }
} 
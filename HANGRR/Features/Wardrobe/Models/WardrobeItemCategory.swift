import Foundation

/// Categories for wardrobe items
public enum WardrobeItemCategory: String, Codable, CaseIterable, Hashable {
    case tops = "Tops"
    case bottoms = "Bottoms"
    case shoes = "Shoes"
    case accessories = "Accessories"
    case outerwear = "Outerwear"
    
    var displayName: String {
        rawValue
    }
} 
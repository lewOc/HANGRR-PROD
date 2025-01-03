import Foundation

/// Categories for wardrobe items
public enum WardrobeItemCategory: String, Codable, CaseIterable, Hashable {
    case top = "Top"
    case bottom = "Bottom"
    case dress = "Dress"
    case accessory = "Accessory"
    case shoes = "Shoes"
    
    var displayName: String {
        rawValue
    }
} 
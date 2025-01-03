import Foundation
import SwiftData

/// A model representing an item in the user's wardrobe
@Model
final class WardrobeItem {
    // MARK: - Properties
    var name: String
    var categoryRawValue: String = WardrobeItemCategory.tops.rawValue
    var createdAt: Date
    var storedImageFileName: String?
    var imageURL: URL?
    
    var category: WardrobeItemCategory {
        get {
            WardrobeItemCategory(rawValue: categoryRawValue) ?? .tops
        }
        set {
            categoryRawValue = newValue.rawValue
        }
    }
    
    // MARK: - Initialization
    init(
        name: String = "New Item",
        category: WardrobeItemCategory = .tops,
        createdAt: Date = .now,
        storedImageFileName: String? = nil,
        imageURL: URL? = nil
    ) {
        self.name = name
        self.categoryRawValue = category.rawValue
        self.createdAt = createdAt
        self.storedImageFileName = storedImageFileName
        self.imageURL = imageURL
    }
} 
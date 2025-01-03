import Foundation
import SwiftData

/// A model representing an item in the user's wardrobe
@Model
final class WardrobeItem {
    // MARK: - Properties
    var name: String
    var categoryRawValue: String = WardrobeItemCategory.top.rawValue
    var createdAt: Date
    var storedImageFileName: String?
    @Transient var imageURL: URL? {
        guard let fileName = storedImageFileName else { return nil }
        return FileManager.default.documentsDirectory.appendingPathComponent(fileName)
    }
    
    var category: WardrobeItemCategory {
        get {
            WardrobeItemCategory(rawValue: categoryRawValue) ?? .top
        }
        set {
            categoryRawValue = newValue.rawValue
        }
    }
    
    // MARK: - Initialization
    init(
        name: String = "New Item",
        category: WardrobeItemCategory = .top,
        createdAt: Date = .now,
        storedImageFileName: String? = nil
    ) {
        self.name = name
        self.categoryRawValue = category.rawValue
        self.createdAt = createdAt
        self.storedImageFileName = storedImageFileName
    }
} 
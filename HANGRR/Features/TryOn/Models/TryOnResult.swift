import Foundation
import SwiftData

@Model
final class TryOnResult {
    var id: String
    var createdAt: Date
    var status: String
    var resultImageURL: String?
    var error: String?
    
    // Relationships
    var modelItem: WardrobeItem?
    var garmentItem: WardrobeItem?
    
    init(
        id: String,
        createdAt: Date = .now,
        status: String = TryOnStatus.starting.rawValue,
        resultImageURL: String? = nil,
        error: String? = nil,
        modelItem: WardrobeItem? = nil,
        garmentItem: WardrobeItem? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.status = status
        self.resultImageURL = resultImageURL
        self.error = error
        self.modelItem = modelItem
        self.garmentItem = garmentItem
    }
} 
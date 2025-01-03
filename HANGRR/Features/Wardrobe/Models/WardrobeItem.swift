import Foundation
import SwiftData

@Model
final class WardrobeItem {
    var id: UUID
    var name: String
    var imageURL: URL?
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, imageURL: URL? = nil, createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.createdAt = createdAt
    }
} 
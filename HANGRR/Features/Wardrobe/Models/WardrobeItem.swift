import Foundation
import SwiftData

@Model
final class WardrobeItem {
    var id: UUID
    var name: String
    private var imageFileName: String? // Store just the filename
    var createdAt: Date
    
    var imageURL: URL? {
        guard let fileName = imageFileName else { return nil }
        return FileManager.default.documentsDirectory.appendingPathComponent(fileName)
    }
    
    init(id: UUID = UUID(), name: String, imageFileName: String? = nil, createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.imageFileName = imageFileName
        self.createdAt = createdAt
    }
} 
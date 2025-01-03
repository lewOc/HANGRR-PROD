import SwiftData
import SwiftUI

enum ModelContainerFactory {
    static var shared: ModelContainer {
        let schema = Schema([WardrobeItem.self])
        let modelConfiguration = ModelConfiguration(schema: schema)
        
        do {
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    static var preview: ModelContainer {
        let schema = Schema([WardrobeItem.self])
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        
        do {
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create preview ModelContainer: \(error)")
        }
    }
} 
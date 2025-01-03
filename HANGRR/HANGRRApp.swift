//
//  HANGRRApp.swift
//  HANGRR
//
//  Created by Work on 02/01/2025.
//

import SwiftUI
import SwiftData

@main
struct HANGRRApp: App {
    let container: ModelContainer = {
        let schema = Schema([WardrobeItem.self])
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            WardrobeView()
        }
        .modelContainer(container)
    }
}

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
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(
                for: Schema([WardrobeItem.self]),
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            WardrobeView()
                .modelContainer(container)
                .preferredColorScheme(.light) // Support dark mode later
                .environment(\.colorScheme, .light)
        }
    }
}

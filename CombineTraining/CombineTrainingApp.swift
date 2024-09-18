//
//  CombineTrainingApp.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 06/09/24.
//

import SwiftUI
import SwiftData

@main
struct CombineTrainingApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Book.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MyBooksView()
        }
        .modelContainer(sharedModelContainer)
    }
}

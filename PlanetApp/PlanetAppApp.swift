//
//  PlanetAppApp.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 17/01/2025.
//

import SwiftUI

@main
struct PlanetAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

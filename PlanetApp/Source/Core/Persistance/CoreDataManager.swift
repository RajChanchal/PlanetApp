//
//  CoreDataManager.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 17/01/2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PlanetApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data loading error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}


//
//  PlanetStorageManager.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 18/01/2025.
//

import Foundation
import CoreData

class PlanetStorageManager: PlanetStorageService {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    /// Fetches planets from the local storage.
    /// - Returns: A `Result` containing an array of `Planet` on success or an error on failure.
    func fetchPlanets() -> Result<[Planet], Error> {
        let request = NSFetchRequest<PlanetEntity>(entityName: PlanetEntity.entity().name ?? "PlanetEntity")
        do {
            let entities = try context.fetch(request)
            let planets = entities.map { Planet(name: $0.name ?? "Unknown") }
            return .success(planets)
        } catch {
            logError("Failed to fetch planets: \(error.localizedDescription)")
            return .failure(StorageError.fetchFailed(underlyingError: error))
        }
    }
    
    /// Saves planets to the local storage.
    /// - Parameter planets: An array of `Planet` to be saved.
    /// - Returns: A `Result` indicating success or failure.
    func savePlanets(_ planets: [Planet]) -> Result<Void, Error> {
        context.performAndWait {
            planets.forEach { planet in
                guard !planet.name.isEmpty else {
                    logError("Skipping a planet with an empty name.")
                    return
                }
                if !doesPlanetExist(named: planet.name) {
                    let entity = PlanetEntity(context: context)
                    entity.name = planet.name
                }
            }
        }
        do {
            try context.save()
            return .success(())
        } catch {
            logError("Failed to save planets: \(error.localizedDescription)")
            return .failure(StorageError.saveFailed(underlyingError: error))
        }
    }
    
    /// Checks if a planet with the given name already exists in the local storage.
    /// - Parameter name: The name of the planet to check.
    /// - Returns: `true` if the planet exists, otherwise `false`.
    func doesPlanetExist(named name: String) -> Bool {
        let request = NSFetchRequest<PlanetEntity>(entityName: PlanetEntity.entity().name ?? "PlanetEntity")
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            logError("Error checking for existing planet: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Logs errors for debugging or monitoring.
    /// - Parameter message: The error message to log.
    private func logError(_ message: String) {
        // TODO: We can replace it with our preferred logging mechanism (e.g., os_log, Crashlytics)
        print("🌍 PlanetStorageManager Error: \(message)")
    }
}

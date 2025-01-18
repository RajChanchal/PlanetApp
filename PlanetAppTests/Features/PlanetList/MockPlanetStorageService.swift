//
//  MockPlanetStorageService.swift
//  PlanetAppTests
//
//  Created by Chanchal Raj on 18/01/2025.
//


import Foundation
@testable import PlanetApp

class MockPlanetStorageService: PlanetStorageService {
    var storedPlanets: [Planet] = []
    var saveCalled = false
    var fetchShouldFail = false
    var saveShouldFail = false

    func fetchPlanets() -> Result<[Planet], Error> {
        if fetchShouldFail {
            return .failure(MockStorageError.fetchFailed)
        }
        return .success(storedPlanets)
    }

    func savePlanets(_ planets: [Planet]) -> Result<Void, Error> {
        saveCalled = true
        if saveShouldFail {
            return .failure(MockStorageError.saveFailed)
        }
        storedPlanets = planets
        return .success(())
    }

    func doesPlanetExist(named name: String) -> Bool {
        return storedPlanets.contains(where: { $0.name == name })
    }
}

enum MockStorageError: Error {
    case fetchFailed
    case saveFailed

    var localizedDescription: String {
        switch self {
        case .fetchFailed:
            return "Mock fetch failed"
        case .saveFailed:
            return "Mock save failed"
        }
    }
}

//
//  MokePlanetRepository.swift
//  PlanetAppTests
//
//  Created by Chanchal Raj on 18/01/2025.
//

import Foundation
import Combine
@testable import PlanetApp

//class MockPlanetRepository: PlanetRepository {
//    var planets: [Planet] = []
//    var shouldFail: Bool = false
//    var fetchPlanetsPublisher = PassthroughSubject<[Planet], Error>()
//    
//    override func fetchPlanets() -> AnyPublisher<[Planet], Error> {
//        if shouldFail {
//            return Fail(error: NSError(domain: "", code: -1, userInfo: nil))
//                .eraseToAnyPublisher()
//        } else {
//            return fetchPlanetsPublisher
//                .eraseToAnyPublisher()
//        }
//    }
//}

//class MockPlanetRepository: PlanetRepository {
//    var planets: [Planet] = []
//    var shouldFail: Bool = false
//    var fetchPlanetsPublisher = PassthroughSubject<[Planet], Error>()
//    
//    override func fetchPlanets() -> AnyPublisher<[Planet], Error> {
//        if shouldFail {
//            // Simulate failure
//            return Fail(error: NSError(domain: "", code: -1, userInfo: nil))
//                .eraseToAnyPublisher()
//        } else {
//            // Emit mock data when it shouldn't fail
//            return fetchPlanetsPublisher
//                .eraseToAnyPublisher()
//        }
//    }
//}


//class MockPlanetRepository: PlanetRepositoryProtocol {
//    var planets: [Planet] = [] // Mocked data
//    var shouldFail: Bool = false // Flag to simulate failure scenarios
//    
//    /// Simulates the `fetchPlanets` method with success or failure based on `shouldFail`.
//    func fetchPlanets() -> AnyPublisher<[Planet], Error> {
//        if shouldFail {
//            // Simulate a failure
//            return Fail(error: NSError(domain: "TestError", code: -1, userInfo: nil))
//                .eraseToAnyPublisher()
//        } else {
//            // Simulate a success with mocked planets
//            return Just(planets)
//                .setFailureType(to: Error.self)
//                .eraseToAnyPublisher()
//        }
//    }
//    
//    /// Simulates the `doesPlanetExist` method.
//    func doesPlanetExist(named name: String) -> Bool {
//        return planets.contains { $0.name == name }
//    }
//}

import Combine
import Foundation

class MockPlanetRepository: PlanetRepositoryProtocol {
    var planets: [Planet] = []
    var shouldFail: Bool = false
    
    func fetchPlanets() -> AnyPublisher<[Planet], Error> {
        if shouldFail {
            let error = NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Custom error message for testing"])
                return Fail(error: error)
                    .eraseToAnyPublisher()
        } else {
            return Just(planets)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func doesPlanetExist(named name: String) -> Bool {
        return planets.contains { $0.name == name }
    }
}

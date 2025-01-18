//
//  PlanetRepository.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 17/01/2025.
//

import Foundation
import Combine


protocol PlanetRepositoryProtocol {
    func fetchPlanets() -> AnyPublisher<[Planet], Error>
    func doesPlanetExist(named name: String) -> Bool
}

class PlanetRepository: PlanetRepositoryProtocol {
    private let networkManager: NetworkService
    private let storageService: PlanetStorageService
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkService = NetworkManager(),
         storageService: PlanetStorageService = PlanetStorageManager()) {
        self.networkManager = networkManager
        self.storageService = storageService
    }
    
    /// Fetches planets from either local storage (if available) or the network.
    /// - Returns: A publisher that emits an array of `Planet` objects or an error.
    func fetchPlanets() -> AnyPublisher<[Planet], Error> {
        if let cachedPlanets = fetchFromLocalStorage(), !cachedPlanets.isEmpty {
            return Just(cachedPlanets)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return fetchFromNetwork()
    }
    
    /// Fetches planets from the local storage.
    /// - Returns: An optional array of `Planet` objects or `nil` if no planets are found.
    private func fetchFromLocalStorage() -> [Planet]? {
        switch storageService.fetchPlanets() {
        case .success(let planets):
            return planets
        case .failure:
            logError(StorageError.fetchFailed(underlyingError: NSError())) // Example of handling failure
            return nil
        }
    }
    
    /// Fetches planets from the network and caches them locally.
    /// - Returns: A publisher that emits an array of `Planet` objects or an error.
    private func fetchFromNetwork() -> AnyPublisher<[Planet], Error> {
        let endpoint = APIEndpoints.getPlanets
        let config = RequestConfiguration(endpoint: endpoint, body: nil)
        
        return networkManager.request(config, responseType: PlanetsResponse.self)
            // Convert API response to `Planet` model.
            .map { $0.results.map { Planet(name: $0.name) } }
            .handleEvents(receiveOutput: { [weak self] planets in
                guard let self = self else { return }
                _ = self.storageService.savePlanets(planets) // Save planets locally.
            })
            .catch { error -> AnyPublisher<[Planet], Error> in
                self.logError(error) // Log the error.
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    /// Logs errors for debugging or analytics purposes.
    /// - Parameter error: The error to be logged.
    private func logError(_ error: Error) {
        //TODO: We can implement logging method like oslog or Crashlytics etc.
        print("Error occurred: \(error.localizedDescription)")
    }
    
    func doesPlanetExist(named name: String) -> Bool {
        return storageService.doesPlanetExist(named: name)
    }
}

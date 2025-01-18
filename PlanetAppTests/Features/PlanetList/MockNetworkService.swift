//
//  MockNetworkService.swift
//  PlanetAppTests
//
//  Created by Chanchal Raj on 18/01/2025.
//

import Foundation
import Combine
@testable import PlanetApp

class MockNetworkService: NetworkService {
    var response: Any? // Used to provide the mocked response
    var shouldFail: Bool = false
    var error: Error = MockNetworkError.genericError
    
    func request<T: Decodable>(_ config: RequestConfiguration, responseType: T.Type) -> AnyPublisher<T, Error> {
        // Load the mock JSON file from the test bundle
        guard let url = Bundle(for: type(of: self)).url(forResource: "MockPlanetsResponse", withExtension: "json") else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return Just(decodedResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}

enum MockNetworkError: Error {
    case genericError
    case invalidResponse

    var localizedDescription: String {
        switch self {
        case .genericError:
            return "Mock network error occurred."
        case .invalidResponse:
            return "Invalid response provided to MockNetworkService."
        }
    }
}

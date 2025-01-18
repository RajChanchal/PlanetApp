//
//  NetworkManager.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 17/01/2025.
//

import Foundation
import Combine

class NetworkManager: NetworkService {
    func request<T: Decodable>(_ config: RequestConfiguration, responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let request = config.urlRequest else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw NetworkError.serverError((output.response as? HTTPURLResponse)?.statusCode ?? -1)
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if error is DecodingError {
                    return NetworkError.decodingFailed
                } else if let urlError = error as? URLError {
                    return NetworkError.map(urlError)
                } else {
                    return NetworkError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}


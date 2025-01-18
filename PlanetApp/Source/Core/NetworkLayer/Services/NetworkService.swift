//
//  NetworkService.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 18/01/2025.
//

import Foundation
import Combine

protocol NetworkService {
    func request<T: Decodable>(_ config: RequestConfiguration, responseType: T.Type) -> AnyPublisher<T, Error>
}

//
//  APIEndpoints.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 17/01/2025.
//

import Foundation

/// Enum representing the API endpoints of the application.
enum APIEndpoints {
    /// Fetches all planets.
    case getPlanets
    /// Creates a new planet with the given data.
    case createPlanet(data: PlanetData)
    /// Searches planets using a query string.
    case searchPlanets(query: String)
    
    /// Path for the specific API endpoint.
    var path: String {
        switch self {
        case .getPlanets,
                .createPlanet,
                .searchPlanets:
            return "/planets"
        }
    }
    
    /// Query parameters for the endpoint, if any.
    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchPlanets(let query):
            return [URLQueryItem(name: "search", value: query)]
        default:
            return nil
        }
    }
    
    /// HTTP method for the endpoint.
    var method: HTTPMethod {
        switch self {
        case .getPlanets,
                .searchPlanets:
            return .get
        case .createPlanet:
            return .post
        }
    }
    
    /// HTTP body for the endpoint, if any.
    var body: Data? {
        switch self {
        case .createPlanet(let data):
            return try? JSONEncoder().encode(data)
        default:
            return nil
        }
    }
}

extension APIEndpoints {
    /// Constructs the full URL for the endpoint, including query parameters.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "swapi.dev"
        components.path = "/api" + path
        components.queryItems = queryItems
        return components.url
    }
}

/// Struct representing the data for creating a new planet.
struct PlanetData: Encodable {
    /// The name of the planet.
    let name: String
}

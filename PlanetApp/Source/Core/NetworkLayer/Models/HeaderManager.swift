//
//  HeaderManager.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 18/01/2025.
//

import Foundation

/// Manages headers for network requests.
struct HeaderManager {
    /// Common headers used for all requests.
    static var commonHeaders: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    /// Adds authentication headers to the common headers.
    /// - Parameter token: The authentication token.
    /// - Returns: A dictionary containing headers with authentication included.
    static func withAuth(token: String) -> [String: String] {
        var headers = commonHeaders
        headers["Authorization"] = "Bearer \(token)"
        return headers
    }
}

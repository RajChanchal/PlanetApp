//
//  StorageError.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 18/01/2025.
//

import Foundation
/// Custom error type for storage-related operations.
enum StorageError: LocalizedError {
    case fetchFailed(underlyingError: Error)
    case saveFailed(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let underlyingError):
            return "Failed to fetch planets: \(underlyingError.localizedDescription)"
        case .saveFailed(let underlyingError):
            return "Failed to save planets: \(underlyingError.localizedDescription)"
        }
    }
}

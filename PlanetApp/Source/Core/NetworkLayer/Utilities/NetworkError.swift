//
//  NetworkError.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 18/01/2025.
//

import Foundation

/// Represents various errors that can occur during network operations.
enum NetworkError: LocalizedError {
    
    /// The URL used for the request is invalid.
    case invalidURL
    
    /// No data was received from the server.
    case noData
    
    /// Failed to decode the server response into the expected model.
    case decodingFailed
    
    /// The device is not connected to the internet.
    case internetNotConnected
    
    /// A server-side error occurred, with an associated HTTP status code.
    /// - Parameter: `Int` - The HTTP status code received from the server.
    case serverError(Int)
    
    /// An unknown error occurred, wrapping the underlying error.
    /// - Parameter: `Error` - The underlying error instance.
    case unknown(Error)
    
    /// Maps a `URLError` to a `NetworkError`.
    ///
    /// This method maps common `URLError` cases, such as no internet connection
    /// or timeout, to their corresponding `NetworkError` representation.
    ///
    /// - Parameter error: The `URLError` instance to be mapped.
    /// - Returns: A corresponding `NetworkError` instance.
    static func map(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet:
            return .internetNotConnected
        case .timedOut:
            return .unknown(error)
        default:
            return .serverError(error.errorCode)
        }
    }
    
    /// Provides a localized description of the error.
    ///
    /// Each error case returns a user-friendly, localized string that can
    /// be displayed to end users. The localization keys are defined in the
    /// corresponding `.strings` file.
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String(localized: "network_error_invalid_url")
        case .noData:
            return String(localized: "network_error_no_data")
        case .decodingFailed:
            return String(localized: "network_error_decoding_failed")
        case .serverError(let statusCode):
            return String(localized: "network_error_server_error\(statusCode)")
        case .unknown(let error):
            return String(localized: "network_error_unknown\(error.localizedDescription)")
        case .internetNotConnected:
            return String(localized: "network_error_no_internet")
        }
    }
}

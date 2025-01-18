//
//  NetworkLogger.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 18/01/2025.
//

import Foundation
struct NetworkLogger {
    static func log(request: URLRequest) {
        print("Request: \(request.httpMethod ?? "N/A") \(request.url?.absoluteString ?? "N/A")")
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
    }
    
    static func log(response: URLResponse, data: Data) {
        if let httpResponse = response as? HTTPURLResponse {
            print("Response: \(httpResponse.statusCode)")
        }
        if let responseBody = String(data: data, encoding: .utf8) {
            print("Response Body: \(responseBody)")
        }
    }
}

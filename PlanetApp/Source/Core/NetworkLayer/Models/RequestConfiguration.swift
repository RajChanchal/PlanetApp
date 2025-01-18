//
//  RequestConfiguration.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 18/01/2025.
//

import Foundation

struct RequestConfiguration {
    let endpoint: APIEndpoints
    var headers: [String: String]?
    let body: Data?
    
    internal init(endpoint: APIEndpoints,
                  headers: [String : String]? = nil,
                  body: Data? = nil) {
        self.endpoint = endpoint
        self.headers = headers
        self.body = body
    }
    
    var urlRequest: URLRequest? {
        guard let url = endpoint.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = headers ?? HeaderManager.commonHeaders
        request.httpBody = body
        return request
    }
}

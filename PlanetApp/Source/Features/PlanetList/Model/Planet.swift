//
//  Planet.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 17/01/2025.
//

import Foundation

struct Planet: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    static func == (lhs: Planet, rhs: Planet) -> Bool {
        lhs.name == rhs.name
    }
}

struct PlanetsResponse: Codable {
    let results: [Planet]
}

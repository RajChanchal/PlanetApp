//
//  PlanetStorageService.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 17/01/2025.
//

import Foundation

protocol PlanetStorageService {
    func fetchPlanets() -> Result<[Planet], Error>
    func savePlanets(_ planets: [Planet]) -> Result<Void, Error>
    func doesPlanetExist(named name: String) -> Bool
}

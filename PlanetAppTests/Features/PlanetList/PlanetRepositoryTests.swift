////
////  PlanetRepositoryTests.swift
////  PlanetAppTests
////
////  Created by Chanchal Raj on 18/01/2025.
////
import XCTest
import Combine
@testable import PlanetApp

class PlanetRepositoryTests: XCTestCase {
    private var repository: PlanetRepository!
    private var mockNetworkService: MockNetworkService!
    private var mockStorageService: MockPlanetStorageService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockStorageService = MockPlanetStorageService()
        repository = PlanetRepository(networkManager: mockNetworkService, storageService: mockStorageService)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        repository = nil
        mockNetworkService = nil
        mockStorageService = nil
        super.tearDown()
    }

    func testFetchPlanetsFromLocalStorageSuccess() {
        // Arrange
        let mockPlanets = [Planet(name: "Earth"), Planet(name: "Mars")]
        mockStorageService.storedPlanets = mockPlanets

        // Act & Assert
        let expectation = self.expectation(description: "Fetch planets from local storage")
        repository.fetchPlanets()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { planets in
                XCTAssertEqual(planets, mockPlanets)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchPlanetsFromNetworkSuccess() {
        // Arrange
        let mockPlanetsResponse = PlanetsResponse(results: [Planet(name: "Venus"), Planet(name: "Jupiter")])
        mockNetworkService.response = mockPlanetsResponse

        // Act & Assert
        let expectation = self.expectation(description: "Fetch planets from network")
        repository.fetchPlanets()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { planets in
                XCTAssertEqual(planets.map { $0.name }, mockPlanetsResponse.results.map { $0.name })
                XCTAssertTrue(self.mockStorageService.saveCalled, "Expected planets to be saved in storage.")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }


    func testDoesPlanetExistReturnsTrue() {
        // Arrange
        let mockPlanets = [Planet(name: "Earth"), Planet(name: "Mars")]
        mockStorageService.storedPlanets = mockPlanets

        // Act
        let exists = repository.doesPlanetExist(named: "Earth")

        // Assert
        XCTAssertTrue(exists, "Expected 'Earth' to exist in storage.")
    }

    func testDoesPlanetExistReturnsFalse() {
        // Arrange
        let mockPlanets = [Planet(name: "Venus"), Planet(name: "Jupiter")]
        mockStorageService.storedPlanets = mockPlanets

        // Act
        let exists = repository.doesPlanetExist(named: "Mars")

        // Assert
        XCTAssertFalse(exists, "Expected 'Mars' to not exist in storage.")
    }
}

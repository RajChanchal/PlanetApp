////
////  PlanetViewModelTests.swift
////  PlanetAppTests
////
////  Created by Chanchal Raj on 18/01/2025.
////

import XCTest
import Combine
@testable import PlanetApp

final class PlanetViewModelTests: XCTestCase {
    private var viewModel: PlanetViewModel!
    private var mockRepository: MockPlanetRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockPlanetRepository()
        viewModel = PlanetViewModel(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchPlanetsSuccess() {
        // Arrange: Mock successful response
        mockRepository.planets = [Planet(name: "Earth")]
        mockRepository.shouldFail = false
        
        let expectation = self.expectation(description: "Fetch planets successfully updates ViewModel")
        
        // Act
        viewModel.$planets
            .dropFirst() // Ignore the initial value
            .sink { planets in
                // Assert: Verify planets data
                XCTAssertEqual(planets.count, 1)
                XCTAssertEqual(planets.first?.name, "Earth")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchPlanets()
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchPlanetsFailure() {
        // Arrange: Mock failure response
        mockRepository.shouldFail = true
        
        let expectation = self.expectation(description: "Fetch planets failure updates ViewModel with error message")
        
        // Act
        viewModel.$errorMessage
            .dropFirst() // Ignore the initial value
            .sink { errorMessage in
                if let errorMessage = errorMessage {
                    // Assert: Verify error message
                    XCTAssertEqual(errorMessage, "Custom error message for testing")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchPlanets()
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testIsLoadingState() {
        // Arrange
        mockRepository.planets = [Planet(name: "Earth")]
        mockRepository.shouldFail = false
        
        let expectation = self.expectation(description: "Loading state updates correctly")
        var loadingStates: [Bool] = []
        
        // Act
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count == 3 { // Expecting: true -> false
                    XCTAssertEqual(loadingStates, [false, true, false])
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchPlanets()
        
        wait(for: [expectation], timeout: 2.0)
    }
}

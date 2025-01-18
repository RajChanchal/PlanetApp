//
//  PlanetStorageManagerTests.swift
//  PlanetAppTests
//
//  Created by Chanchal Raj on 18/01/2025.
//

import XCTest
import CoreData

@testable import PlanetApp

//final class PlanetStorageManagerTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}

final class PlanetStorageManagerTests: XCTestCase {
    var storageManager: PlanetStorageManager!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        // Setup an in-memory Core Data stack for testing
        let persistentContainer = NSPersistentContainer(name: "PlanetApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error, "Failed to set up in-memory Core Data stack: \(String(describing: error))")
        }
        mockContext = persistentContainer.viewContext
        storageManager = PlanetStorageManager(context: mockContext)
    }
    
    override func tearDown() {
        mockContext = nil
        storageManager = nil
        super.tearDown()
    }
    
    /// Tests fetching planets from an empty storage.
    func testFetchPlanets_emptyStorage() {
        let result = storageManager.fetchPlanets()
        switch result {
        case .success(let planets):
            XCTAssertTrue(planets.isEmpty, "Expected no planets in storage, but found \(planets.count).")
        case .failure(let error):
            XCTFail("Expected success, but got failure with error: \(error).")
        }
    }
    
    /// Tests fetching planets when the storage contains data.
    func testFetchPlanets_withData() {
        let planetEntity = PlanetEntity(context: mockContext)
        planetEntity.name = "Earth"
        try? mockContext.save()
        
        let result = storageManager.fetchPlanets()
        switch result {
        case .success(let planets):
            XCTAssertEqual(planets.count, 1)
            XCTAssertEqual(planets.first?.name, "Earth")
        case .failure(let error):
            XCTFail("Expected success, but got failure with error: \(error).")
        }
    }
    
    /// Tests saving a list of valid planets to storage.
    func testSavePlanets_validPlanets() {
        let planets = [Planet(name: "Earth"), Planet(name: "Mars")]
        let result = storageManager.savePlanets(planets)
        
        switch result {
        case .success:
            let fetchResult = storageManager.fetchPlanets()
            switch fetchResult {
            case .success(let fetchedPlanets):
                XCTAssertEqual(fetchedPlanets.count, 2)
                XCTAssertTrue(fetchedPlanets.contains { $0.name == "Earth" })
                XCTAssertTrue(fetchedPlanets.contains { $0.name == "Mars" })
            case .failure(let error):
                XCTFail("Fetch failed with error: \(error).")
            }
        case .failure(let error):
            XCTFail("Save failed with error: \(error).")
        }
    }
    
    /// Tests skipping planets with empty names during saving.
    func testSavePlanets_skipEmptyName() {
        let planets = [Planet(name: "Earth"), Planet(name: "")]
        let result = storageManager.savePlanets(planets)
        
        switch result {
        case .success:
            let fetchResult = storageManager.fetchPlanets()
            switch fetchResult {
            case .success(let fetchedPlanets):
                XCTAssertEqual(fetchedPlanets.count, 1)
                XCTAssertTrue(fetchedPlanets.contains { $0.name == "Earth" })
            case .failure(let error):
                XCTFail("Fetch failed with error: \(error).")
            }
        case .failure(let error):
            XCTFail("Save failed with error: \(error).")
        }
    }
    
    /// Tests if `doesPlanetExist` correctly identifies an existing planet.
    func testDoesPlanetExist_existingPlanet() {
        let planetEntity = PlanetEntity(context: mockContext)
        planetEntity.name = "Earth"
        try? mockContext.save()
        
        XCTAssertTrue(storageManager.doesPlanetExist(named: "Earth"))
    }
    
    /// Tests if `doesPlanetExist` correctly identifies a non-existing planet
    func testDoesPlanetExist_nonExistingPlanet() {
        XCTAssertFalse(storageManager.doesPlanetExist(named: "Mars"))
    }
}

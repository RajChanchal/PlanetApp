//
//  PlanetViewModel.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 17/01/2025.
//

import Foundation
import Combine

/// The `PlanetViewModel` class serves as the ViewModel in the MVVM (Model-View-ViewModel) design pattern.
/// It provides an observable interface for views to consume planet data and manage loading/error states.
class PlanetViewModel: ObservableObject {
    // MARK: - Published Properties
    /// A list of `Planet` objects fetched from the repository. Updates to this property will notify any observing views.
    @Published var planets: [Planet] = []
    
    /// Indicates whether a fetch operation is in progress. Useful for showing loading indicators in the UI.
    @Published var isLoading: Bool = false
    
    /// Stores an error message if a fetch operation fails. Can be displayed to the user for feedback.
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    /// A set of `AnyCancellable` objects used to manage Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// A repository conforming to `PlanetRepositoryProtocol` that serves as the data source for fetching planets.
    private let repository: PlanetRepositoryProtocol
    
    // MARK: - Initializer
    /// Initializes the `PlanetViewModel` with a specified repository for dependency injection.
    /// - Parameter repository: An object conforming to `PlanetRepositoryProtocol`. Defaults to `PlanetRepository`.
    init(repository: PlanetRepositoryProtocol = PlanetRepository()) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    /// Fetches planets from the repository. Manages loading and error states accordingly.
    ///
    /// - The method sets `isLoading` to `true` before starting the operation and resets it once the fetch completes.
    /// - In case of success, the `planets` property is updated with the fetched data.
    /// - In case of failure, the `errorMessage` property is updated with a descriptive error.
    func fetchPlanets() {
        setLoadingState(to: true)
        resetErrorMessage()
        
        repository.fetchPlanets()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handleCompletion, receiveValue: handleSuccess)
            .store(in: &cancellables)
    }
    
    // MARK: - Private Helper Methods
    
    /// Sets the `isLoading` state.
    /// - Parameter isLoading: A boolean value indicating whether the loading state is active.
    private func setLoadingState(to isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    /// Resets the `errorMessage` to `nil`, clearing any previous error messages.
    private func resetErrorMessage() {
        self.errorMessage = nil
    }
    
    /// Handles the completion of the `fetchPlanets` operation.
    /// - Parameter completion: A `Subscribers.Completion` object representing the operation's result (success or failure).
    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        setLoadingState(to: false)
        
        if case .failure(let error) = completion {
            self.errorMessage = error.localizedDescription
        }
    }
    
    /// Handles the successful fetch of planets.
    /// - Parameter planets: An array of `Planet` objects fetched from the repository.
    private func handleSuccess(planets: [Planet]) {
        self.planets = planets
    }
}

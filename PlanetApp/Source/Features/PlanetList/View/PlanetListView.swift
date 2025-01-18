//
//  PlanetListView.swift
//  PlanetApp
//
//  Created by Chanchal Raj on 17/01/2025.
//

import SwiftUI

struct PlanetListView: View {
    @StateObject private var viewModel = PlanetViewModel()
    
    var body: some View {
        NavigationView {
            Group{
                if viewModel.isLoading {
                    ProgressView(String(localized: "planet_list_view_loading_planets"))
                } else if let error = viewModel.errorMessage {
                    Text("\(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.planets.isEmpty {
                    Text(String(localized: "planet_list_view_empty"))
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.planets) { planet in
                        Text(planet.name)
                    }
                }
            }
            .navigationTitle(String(localized: "planet_list_view_title"))
            .onAppear {
                viewModel.fetchPlanets()
            }
        }
    }
}



#Preview {
    PlanetListView()
}

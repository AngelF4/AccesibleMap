//
//  HomeViewModel.swift
//  AccesibleMap
//
//  Created by OpenAI Assistant on 10/10/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var venues: [Venue] = []
    @Published var selectedVenue: Venue?

    init() {
        loadVenues()
    }

    func selectVenue(at index: Int) {
        guard venues.indices.contains(index) else { return }
        selectedVenue = venues[index]
    }

    private func loadVenues() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        if let url = Bundle.main.url(forResource: "venues", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? decoder.decode([Venue].self, from: data),
           !decoded.isEmpty {
            venues = decoded
            selectedVenue = decoded.first
            return
        }

        venues = Venue.defaultVenues
        selectedVenue = venues.first
    }
}

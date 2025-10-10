//
//  HomeViewModel.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 09/10/25.
//

import Foundation
import Combine
import MapKit
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var showVenueList = false
    @Published var mapPosition: MapCameraPosition = .automatic
    @Published var cities: [City] = []
    @Published var selectedCity: City?
    @Published var venues: [Venue] = []
    @Published var position: Venue?
    @Published var selectedVenue: Venue?


    let cameras = VenuesCamera().cameras
    let geo = DIContainer.shared.geo

    init() {
#if DEBUG
        self.cities = City.mocks
#else
        let monterrey = City(
            name: "Monterrey",
            coordinate: .init(latitude: 25.686613, longitude: -100.316116),
            venues: [geo.venueBBVA]
        )
        self.cities = [monterrey]
#endif
        if let firstCity = cities.first {
            setCity(firstCity)
        }
    }

    func prepareInitialState() {
        guard !cities.isEmpty else { return }

        if let currentCity = selectedCity {
            if venues.isEmpty {
                venues = currentCity.venues
            }
            if position == nil {
                position = currentCity.venues.first
            }
        } else if let firstCity = cities.first {
            setCity(firstCity)
        }
    }

    func setCity(_ city: City) {
        selectedCity = city
        venues = city.venues
        position = venues.first
        selectedVenue = nil
    }

    func handleBackNavigation() {
        if selectedVenue != nil {
            selectedVenue = nil
        } else {
            showVenueList = false
        }
    }

    private func getRandomCamera() -> MapCamera {
        if let randomVenue = cities.flatMap({ $0.venues }).randomElement() {
            return MapCamera(
                centerCoordinate: randomVenue.center,
                distance: 9000,
                heading: 0,
                pitch: 35
            )
        }

        return cameras.randomElement() ?? MapCamera(
            centerCoordinate: .init(
                latitude: 25.669122,
                longitude: -100.244362
            ),
            distance: 1200,
            heading: -30,
            pitch: 64
        )
    }

    var cameraToShow: MapCamera {
        if let venue = selectedVenue {
            return MapCamera(
                centerCoordinate: venue.center,
                distance: 3000,
                heading: 0,
                pitch: 0
            )
        }

        if showVenueList {
            if let venue = position ?? venues.first {
                return MapCamera(
                    centerCoordinate: venue.center,
                    distance: 9000,
                    heading: 0,
                    pitch: 35
                )
            } else if let city = selectedCity {
                return MapCamera(
                    centerCoordinate: city.coordinate,
                    distance: 70000,
                    heading: 0,
                    pitch: 35
                )
            }
        }

        return getRandomCamera()
    }
}


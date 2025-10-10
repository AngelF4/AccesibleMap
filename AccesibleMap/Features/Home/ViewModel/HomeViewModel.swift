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
    @Published var cityPosition: City?
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
        self.cityPosition = cities.first
    }

    func prepareInitialState() {
        if cityPosition == nil {
            cityPosition = cities.first
        }

        if let city = selectedCity, position == nil {
            position = city.venues.first
        }
    }

    func selectCurrentCity() {
        guard let city = cityPosition else { return }
        selectedCity = city
        selectedVenue = nil
        venues = city.venues
        position = venues.first
    }

    func resetToCitySelection() {
        selectedCity = nil
        selectedVenue = nil
        venues = []
        position = nil
    }

    func handleBackNavigation() {
        if selectedVenue != nil {
            selectedVenue = nil
        } else if selectedCity != nil {
            resetToCitySelection()
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
            if let city = selectedCity {
                if let venue = position ?? city.venues.first {
                    return MapCamera(
                        centerCoordinate: venue.center,
                        distance: 9000,
                        heading: 0,
                        pitch: 35
                    )
                }
            } else if let city = cityPosition ?? cities.first {
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


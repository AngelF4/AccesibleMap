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
    @Published var venues: [Venue] = []
    @Published var position: Venue?
    @Published var selectedVenue: Venue?

    private let defaultCameraAnimation: Animation = .spring(duration: 1)
    private let carouselCameraAnimation: Animation = .spring(duration: 1.1)
    private let selectionCameraAnimation: Animation = .spring(duration: 1)


    let cameras = VenuesCamera().cameras
    let geo = DIContainer.shared.geo

    init() {
#if DEBUG
        self.venues = Venue.mocks
#else
        venues.append(geo.venueBBVA)
#endif
    }
    
    private func getRandomCamera() -> MapCamera {
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
            } else {
                return MapCamera(
                    centerCoordinate: .init(
                        latitude: 25.669122,
                        longitude: -100.244362
                    ),
                    distance: 9000,
                    heading: 0,
                    pitch: 35
                )
            }
        }

        return getRandomCamera()
    }

    func updateMapPosition(animated: Bool = true, animation: Animation? = nil, overrideCamera: MapCamera? = nil) {
        let targetCamera = overrideCamera ?? cameraToShow
        let newPosition = MapCameraPosition.camera(targetCamera)

        guard animated else {
            mapPosition = newPosition
            return
        }

        withAnimation(animation ?? defaultCameraAnimation) {
            mapPosition = newPosition
        }
    }

    func focusOnSelectedVenue(animated: Bool = true) {
        guard let venue = selectedVenue else {
            updateMapPosition(animated: animated)
            return
        }

        let camera = MapCamera(
            centerCoordinate: venue.center,
            distance: 3000,
            heading: 0,
            pitch: 0
        )

        updateMapPosition(animated: animated, animation: selectionCameraAnimation, overrideCamera: camera)
    }

    func focusOnVenueFromCarousel(animated: Bool = true) {
        updateMapPosition(animated: animated, animation: carouselCameraAnimation)
    }
}


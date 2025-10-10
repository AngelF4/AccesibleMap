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
                pitch: 45
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
}


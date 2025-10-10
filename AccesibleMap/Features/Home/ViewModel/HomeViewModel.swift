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
        if showVenueList {
            if let venue = position {
                // Focus on the selected venue while the list is shown
                return MapCamera(
                    centerCoordinate: venue.center,
                    distance: 10000
                )
            } else {
                // Default wide view when no venue is selected
                return MapCamera(
                    centerCoordinate: .init(
                        latitude: 25.669122,
                        longitude: -100.244362
                    ),
                    distance: 10000
                )
            }
        } else {
            return getRandomCamera()
        }
    }
}


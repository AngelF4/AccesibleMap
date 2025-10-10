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
    
    // NUEVO: flujo por ciudad
    @Published var selectedCity: City? = nil
    @Published var positionCity: City? = nil
    
    // Ciudades disponibles en base a las sedes cargadas (ordenadas)
    var cities: [City] {
        Array(Set(venues.map(\.city))).sorted { $0.sortOrder < $1.sortOrder }
    }
    
    // Sedes filtradas por la ciudad seleccionada
    var venuesInSelectedCity: [Venue] {
        guard let city = selectedCity else { return [] }
        return venues.filter { $0.city == city }
    }
    
    let cameras = VenuesCamera().cameras
    let geo = DIContainer.shared.geo
    
    init() {
#if DEBUG
        self.venues = Venue.mocks
#else
        venues.append(geo.venueBBVA)
#endif
        self.positionCity = cities.first
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
        // 1) Si ya hay sede seleccionada, centra en la sede
        if let venue = selectedVenue {
            return MapCamera(
                centerCoordinate: venue.center,
                distance: 3000,
                heading: 0,
                pitch: 0
            )
        }
        
        // 2) En flujo de lista, prioriza la selección actual del carrusel
        if showVenueList {
            // Si estamos en el paso de sedes y hay una sede "posicionada" en el pager, céntrala
            if let venue = position {
                return MapCamera(
                    centerCoordinate: venue.center,
                    distance: 9000,
                    heading: 0,
                    pitch: 35
                )
            }
            
            // Si estamos en el paso de ciudades (o aún no hay sede posicionada), céntrate en la ciudad seleccionada/posicionada
            if let city = selectedCity ?? positionCity ?? cities.first {
                return MapCamera(
                    centerCoordinate: city.center,
                    distance: 500000,
                    heading: 0,
                    pitch: 10
                )
            }
            
            // Fallback dentro del flujo de lista
            if let venue = venues.first {
                return MapCamera(
                    centerCoordinate: venue.center,
                    distance: 9000,
                    heading: 0,
                    pitch: 35
                )
            }
        }
        
        // 3) Pantalla inicial (hero)
        return getRandomCamera()
    }
}

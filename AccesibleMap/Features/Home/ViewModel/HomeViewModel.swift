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
    
    enum Step {
        case hero
        case cityList
        case venueList
        case venueDetail
    }
    
    var step: Step {
        if !showVenueList { return .hero }
        if selectedCity == nil { return .cityList }
        if selectedCity != nil && selectedVenue == nil { return .venueList }
        if selectedVenue != nil { return .venueDetail }
        return .venueList
    }
    
    // Estado de cámara (desde la Vista)
    @Published var cameraInfo: MapCamera? = nil
    
    // Filtros de UI (MVVM)
    @Published var selectedFloor: Int = 0
//    @Published var showOnlyEssentials: Bool = true
    
    // NUEVO: flujo por ciudad
    @Published var selectedCity: City? = nil
    @Published var positionCity: City? = nil
    
    // MARK: - Intents (acciones desde la Vista)
    func onAppear() {
        mapPosition = .camera(cameraToShow)
        positionCity = cities.first
    }
    
    func showList() {
        showVenueList = true
        positionCity = cities.first
        syncCameraForStateChange(animated: true, duration: 0.4)
    }
    
    func pageCityChanged(to index: Int) {
        if cities.indices.contains(index) { positionCity = cities[index] }
    }
    
    func confirmCitySelection() {
        selectedCity = positionCity ?? cities.first
        position = venuesInSelectedCity.first
        syncCameraForStateChange(animated: true, duration: 0.9)
    }
    
    func pageVenueChanged(to index: Int) {
        if venuesInSelectedCity.indices.contains(index) { position = venuesInSelectedCity[index] }
    }
    
    func confirmVenueSelection() {
        selectedVenue = position
        syncCameraForStateChange(animated: true, duration: 0.4)
        
    }
    
    func goBack() {
        if selectedVenue != nil {
            // Salir del detalle: volvemos a la lista de sedes, mantenemos 'position'
            selectedVenue = nil
        } else if selectedCity != nil {
            // Salir de la lista de sedes a la lista de ciudades: limpiar 'position'
            selectedCity = nil
            position = nil
        } else {
            // Salir del flujo de listas: limpiar selecciones
            showVenueList = false
            position = nil
        }
        syncCameraForStateChange(animated: true, duration: 0.8)
    }
    
    // Ciudades disponibles en base a las sedes cargadas (ordenadas)
    var cities: [City] {
        Array(Set(venues.map(\.city))).sorted { $0.sortOrder < $1.sortOrder }
    }
    
    // Sedes filtradas por la ciudad seleccionada
    var venuesInSelectedCity: [Venue] {
        guard let city = selectedCity else { return [] }
        return venues.filter { $0.city == city }
    }
    
    // --- Helpers de pisos/POIs ---
    func availableFloors(for venue: Venue) -> [Int] {
        let floors = Set(venue.pois.map(\.floor))
        return floors.sorted()
    }
    
    func filteredPOIs(for venue: Venue) -> [VenuePOI] {
        let base = venue.pois.filter { $0.floor == selectedFloor }
//        if showOnlyEssentials {
//            return base.filter { poi in
//                poi.type == .parking || poi.type == .access || poi.type == .accessWheelchair
//            }
//        }
        return base
    }
    
    var cameraDistance: CLLocationDistance {
        cameraInfo?.distance ?? .greatestFiniteMagnitude
    }
    
    var shouldShowPOIs: Bool {
        cameraDistance <= 4000
    }
    
    var isFarFromSelectedVenue: Bool {
        guard let venue = selectedVenue, let cam = cameraInfo else { return false }
        let v = CLLocation(latitude: venue.center.latitude, longitude: venue.center.longitude)
        let c = CLLocation(latitude: cam.centerCoordinate.latitude, longitude: cam.centerCoordinate.longitude)
        let centerDistance = v.distance(from: c)
        let zoomDistance = cameraInfo?.distance ?? .greatestFiniteMagnitude
        return centerDistance > 400 || zoomDistance > 5000
    }
    
    // Sincroniza la cámara con el estado actual
    func syncCameraForStateChange(animated: Bool = true, duration: Double = 0.4) {
        let camera = cameraToShow
        if animated {
            withAnimation(.spring(duration: duration)) {
                mapPosition = .camera(camera)
            }
        } else {
            mapPosition = .camera(camera)
        }
    }
    
    // MARK: - Datos auxiliares
    let cameras = VenuesCamera().cameras
    let geo = DIContainer.shared.geo
    
    init() {
//#if DEBUG
//        self.venues = Venue.mocks
//#else
        venues.append(geo.venueBBVA)
//#endif
        onAppear()
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

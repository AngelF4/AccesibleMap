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
import SwiftUIPager

class HomeViewModel: ObservableObject {
    @Published var showVenueList = false
    @Published var mapPosition: MapCameraPosition = .automatic
    @Published var venues: [Venue] = []
    @Published var position: Venue?
    @Published var selectedVenue: Venue?
    @Published var lastVisitedVenue: Venue?
    @Published var pageVenue = Page.withIndex(0)
    @Published var pageCity = Page.withIndex(0)
    
    private func alignPagers(for city: City) {
        if let cidx = indexForCity(city) {
            pageCity = Page.withIndex(cidx)
        }
        pageVenue = Page.withIndex(0)
    }
    
    private func alignVenuePager(to venue: Venue) {
        if let vidx = indexForVenue(venue) {
            pageVenue = Page.withIndex(vidx)
        }
    }
    
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
    private var allCategories: Set<pointOfInterest> { Set(pointOfInterest.allCases) }
    @Published var selectedCategories: Set<pointOfInterest> = Set(pointOfInterest.allCases)
    @Published var showCategoryFilters: Bool = false
    //    @Published var showOnlyEssentials: Bool = true
    
    // flujo por ciudad
    @Published var selectedCity: City? = nil
    @Published var positionCity: City? = nil
    
    // --- Helpers de categorías ---
    func isCategoryOn(_ poi: pointOfInterest) -> Bool {
        selectedCategories.contains(poi)
    }
    
    func setCategory(_ poi: pointOfInterest, to isOn: Bool) {
        if isOn {
            selectedCategories.insert(poi)
        } else {
            selectedCategories.remove(poi)
        }
    }
    
    func resetCategories(selectAll: Bool = true) {
        if selectAll {
            selectedCategories = Set(pointOfInterest.allCases)
        } else {
            selectedCategories.removeAll()
        }
    }
    
    var isUsingCategoryFilters: Bool {
        selectedCategories != allCategories
    }
    
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
        let city = positionCity ?? cities.first
        selectedCity = city
        positionCity = city
        if let city { alignPagers(for: city) }
        position = venuesInSelectedCity.first
        syncCameraForStateChange(animated: true, duration: 0.9)
    }
    
    func confirmCitySelection(_ city: City) {
        selectedCity = city
        positionCity = city
        alignPagers(for: city)
        position = venuesInSelectedCity.first
        syncCameraForStateChange(animated: true, duration: 0.9)
    }
    
    func pageVenueChanged(to index: Int) {
        if venuesInSelectedCity.indices.contains(index) { position = venuesInSelectedCity[index] }
    }
    
    func confirmVenueSelection() {
        selectedVenue = position
        if let selectedVenue {
            // Asegura que la ciudad quede bloqueada a la del venue
            if selectedCity != selectedVenue.city {
                selectedCity = selectedVenue.city
                positionCity = selectedVenue.city
                // Alinea solo el pager de ciudades; NO reinicies el pager de sedes aquí
                if let cidx = indexForCity(selectedVenue.city) {
                    pageCity = Page.withIndex(cidx)
                }
            }
            // Mantén 'position' y alinea el pager de sedes al venue actual
            position = selectedVenue
            alignVenuePager(to: selectedVenue)
            setLastVisitedVenue(selectedVenue)
        }
        syncCameraForStateChange(animated: true, duration: 0.4)
    }
    
    func confirmVenueSelection(_ venue: Venue) {
        // Asegura que la ciudad quede bloqueada a la del venue
        if selectedCity != venue.city {
            selectedCity = venue.city
            positionCity = venue.city
            // Alinea solo el pager de ciudades; NO reinicies el pager de sedes aquí
            if let cidx = indexForCity(venue.city) {
                pageCity = Page.withIndex(cidx)
            }
        }
        // Mantén 'position' y alinea el pager de sedes al venue confirmado
        position = venue
        selectedVenue = venue
        alignVenuePager(to: venue)
        setLastVisitedVenue(venue)
        syncCameraForStateChange(animated: true, duration: 0.4)
    }
    
    func goBack() {
        if selectedVenue != nil {
            // Salir del detalle: volvemos a la lista de sedes y conservamos la posición del carrusel
            let currentSelected = selectedVenue
            selectedVenue = nil
            
            // Si no hay una position válida, usa la última visitada (si es de la misma ciudad) o la primera sede
            if position == nil {
                if let last = lastVisitedVenue, last.city == selectedCity {
                    position = last
                } else {
                    position = venuesInSelectedCity.first
                }
            } else if let currentSelected, position?.id != currentSelected.id {
                // Si hubo un venue seleccionado diferente a la position, alineamos la position al seleccionado
                position = currentSelected
            }
            // Asegura que los pagers queden alineados con la ciudad y el venue actual
            if let city = selectedCity, let cidx = indexForCity(city) {
                pageCity = Page.withIndex(cidx)
            }
            if let pos = position {
                alignVenuePager(to: pos)
            }
        } else if selectedCity != nil {
            // Salir de la lista de sedes a la lista de ciudades: limpiar position y resetear pager
            selectedCity = nil
            position = nil
            pageVenue = Page.withIndex(0)
        } else {
            // Salir del flujo: limpiar todo y regresar al héroe
            showVenueList = false
            selectedCity = nil
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
        return base.filter { selectedCategories.contains($0.type) }
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
    private let defaults = UserDefaults.standard
    private let lastVisitedVenueKey = "lastVisitedVenueName"
    
    init() {
        //#if DEBUG
        //        self.venues = Venue.mocks
        //#else
        venues = geo.venues
        //#endif
        loadLastVisitedVenue()
        onAppear()
    }
    
    private func loadLastVisitedVenue() {
        guard
            let name = defaults.string(forKey: lastVisitedVenueKey),
            let venue = venues.first(where: { $0.name == name })
        else {
            lastVisitedVenue = nil
            return
        }
        lastVisitedVenue = venue
    }
    
    private func setLastVisitedVenue(_ venue: Venue) {
        guard
            let storedVenue = venues.first(where: { $0.id == venue.id })
                ?? venues.first(where: { $0.name == venue.name })
        else { return }
        
        lastVisitedVenue = storedVenue
        defaults.set(storedVenue.name, forKey: lastVisitedVenueKey)
    }
    
    func indexForCity(_ city: City) -> Int? {
        cities.firstIndex(of: city)
    }
    
    func indexForVenue(_ venue: Venue) -> Int? {
        venues(in: venue.city).firstIndex(where: { $0.id == venue.id })
        ?? venues(in: venue.city).firstIndex(where: { $0.name == venue.name })
    }
    
    private func venues(in city: City) -> [Venue] {
        venues.filter { $0.city == city }
    }
    
    func openLastVisitedVenue() {
        guard let venue = lastVisitedVenue else { return }
        
        showVenueList = true
        selectedCity = venue.city
        positionCity = venue.city
        position = venue
        selectedVenue = venue
        setLastVisitedVenue(venue)
        syncCameraForStateChange(animated: true, duration: 0.4)
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

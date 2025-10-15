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
    
    // ---- Filtros (UI)
    @Published var selectedFloor: Int = 0
    private var allCategories: Set<pointOfInterest> { Set(pointOfInterest.allCases) }
    @Published var selectedCategories: Set<pointOfInterest> = Set(pointOfInterest.allCases)
    @Published var showCategoryFilters: Bool = false
    
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
        positionCity = cities.first
    }
    
    func showList() {
        showVenueList = true
        positionCity = cities.first
        // La vista sincroniza la cámara con MapaViewModel al detectar este cambio.
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
        // La vista sincroniza la cámara con MapaViewModel.
    }
    
    func confirmCitySelection(_ city: City) {
        selectedCity = city
        positionCity = city
        alignPagers(for: city)
        position = venuesInSelectedCity.first
    }
    
    func pageVenueChanged(to index: Int) {
        if venuesInSelectedCity.indices.contains(index) { position = venuesInSelectedCity[index] }
    }
    
    func confirmVenueSelection() {
        selectedVenue = position
        if let selectedVenue {
            if selectedCity != selectedVenue.city {
                selectedCity = selectedVenue.city
                positionCity = selectedVenue.city
                if let cidx = indexForCity(selectedVenue.city) {
                    pageCity = Page.withIndex(cidx)
                }
            }
            position = selectedVenue
            alignVenuePager(to: selectedVenue)
            setLastVisitedVenue(selectedVenue)
        }
    }
    
    func confirmVenueSelection(_ venue: Venue) {
        if selectedCity != venue.city {
            selectedCity = venue.city
            positionCity = venue.city
            if let cidx = indexForCity(venue.city) {
                pageCity = Page.withIndex(cidx)
            }
        }
        position = venue
        selectedVenue = venue
        alignVenuePager(to: venue)
        setLastVisitedVenue(venue)
    }
    
    func goBack() {
        if selectedVenue != nil {
            let currentSelected = selectedVenue
            selectedVenue = nil
            
            if position == nil {
                if let last = lastVisitedVenue, last.city == selectedCity {
                    position = last
                } else {
                    position = venuesInSelectedCity.first
                }
            } else if let currentSelected, position?.id != currentSelected.id {
                position = currentSelected
            }
            if let city = selectedCity, let cidx = indexForCity(city) {
                pageCity = Page.withIndex(cidx)
            }
            if let pos = position {
                alignVenuePager(to: pos)
            }
        } else if selectedCity != nil {
            selectedCity = nil
            position = nil
            pageVenue = Page.withIndex(0)
        } else {
            showVenueList = false
            selectedCity = nil
            pageCity.index = 0
            pageVenue.index = 0
            position = nil
        }
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
    
    // MARK: - Datos auxiliares
    let geo = DIContainer.shared.geo
    private let defaults = UserDefaults.standard
    private let lastVisitedVenueKey = "lastVisitedVenueName"
    
    init() {
        venues = geo.venues
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
    }
    
    //Para sincronizar HomeVM con el MapaViewModel
    var exportedState: HomeSelection {
        HomeSelection(
            showVenueList: showVenueList,
            selectedCity: selectedCity,
            positionedCity: positionCity,
            selectedVenue: selectedVenue,
            positionedVenue: position,
            venues: venues,
            cities: cities
        )
    }
}

//
//  MapaViewModel.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 15/10/25.
//

import Foundation
import Combine
import SwiftUI
import MapKit

struct HomeSelection {
    let showVenueList: Bool
    let selectedCity: City?
    let positionedCity: City?
    let selectedVenue: Venue?
    let positionedVenue: Venue?
    let venues: [Venue]
    let cities: [City]
}

final class MapaViewModel: ObservableObject {
    @Published var mapPosition: MapCameraPosition = .automatic
    @Published var cameraInfo: MapCamera? = nil
    
    private let cameras = VenuesCamera().cameras
    
    // MARK: - Sync
    func apply(_ state: HomeSelection, animated: Bool = true, duration: Double = 0.4) {
        let camera = cameraToShow(from: state)
        if animated {
            withAnimation(.spring(duration: duration)) {
                mapPosition = .camera(camera)
            }
        } else {
            mapPosition = .camera(camera)
        }
    }
    
    // MARK: - Camera derivations
    var cameraDistance: CLLocationDistance {
        cameraInfo?.distance ?? .greatestFiniteMagnitude
    }
    
    var shouldShowPOIs: Bool {
        cameraDistance <= 4000
    }
    
    func isFarFromSelectedVenue(for venue: Venue?) -> Bool {
        guard let venue, let cam = cameraInfo else { return false }
        let v = CLLocation(latitude: venue.center.latitude, longitude: venue.center.longitude)
        let c = CLLocation(latitude: cam.centerCoordinate.latitude, longitude: cam.centerCoordinate.longitude)
        let centerDistance = v.distance(from: c)
        let zoomDistance = cameraInfo?.distance ?? .greatestFiniteMagnitude
        return centerDistance > 400 || zoomDistance > 5000
    }
    
    // MARK: - Render helpers
    func isAccessLike(_ type: pointOfInterest) -> Bool {
        switch type {
        case .access, .accessWheelchair, .parking: return true
        default: return false
        }
    }
    
    enum RevealLevel { case hidden, dots, icons, labeled }
    
    /// Umbrales diferenciados: accesos/entradas visibles desde más lejos
    func revealLevel(distance: CLLocationDistance, for type: pointOfInterest) -> RevealLevel {
        // Otros POIs
        let farHiddenOther: CLLocationDistance = 3000
        let farDotsOther: CLLocationDistance = 1500
        let nearIconsOther: CLLocationDistance = 500
        
        // Accesos/entradas
        let farHiddenAccess: CLLocationDistance = 5000
        let farDotsAccess: CLLocationDistance = 4000
        let nearIconsAccess: CLLocationDistance = 200
        
        let access = isAccessLike(type)
        if access {
            if distance > farHiddenAccess { return .hidden }
            else if distance > farDotsAccess { return .dots }
            else if distance > nearIconsAccess { return .icons }
            else { return .labeled }
        } else {
            if distance > farHiddenOther { return .hidden }
            else if distance > farDotsOther { return .dots }
            else if distance > nearIconsOther { return .icons }
            else { return .labeled }
        }
    }
    
    func scaleForZoom(_ distance: CLLocationDistance) -> CGFloat {
        let minD: CLLocationDistance = 800
        let maxD: CLLocationDistance = 3000
        let t = min(1, max(0, (distance - minD) / (maxD - minD)))
        return 1.0 - 0.4 * t
    }
    
    func filteredPOIs(in venue: Venue, floor: Int, categories: Set<pointOfInterest>) -> [VenuePOI] {
        let base = venue.pois.filter { $0.floor == floor }
        return base.filter { categories.contains($0.type) }
    }
    
    // POI listo para renderizar (incluye el nivel de reveal ya calculado)
    struct RenderablePOI: Identifiable {
        var id: UUID { poi.id }
        let poi: VenuePOI
        let level: RevealLevel
    }
    
    /// Decide el nivel de render para un POI dado la distancia actual (o una provista).
    func renderLevel(for poi: VenuePOI, distance: CLLocationDistance? = nil) -> RevealLevel {
        let dist = distance ?? cameraDistance
        let accessLike = isAccessLike(poi.type)
        // Permitir que accesos/entradas vivan más lejos aunque shouldShowPOIs sea false
        let extendedVisibility = dist <= 6000 && accessLike
        let canRender = shouldShowPOIs || extendedVisibility
        guard canRender else { return .hidden }
        return revealLevel(distance: dist, for: poi.type)
    }
    
    /// Lista de POIs visibles para un venue/piso/categorías, con su nivel de render ya calculado.
    func visiblePOIs(for venue: Venue, floor: Int, categories: Set<pointOfInterest>) -> [RenderablePOI] {
        let base = filteredPOIs(in: venue, floor: floor, categories: categories)
        let dist = cameraDistance
        return base.compactMap { poi in
            let level = renderLevel(for: poi, distance: dist)
            return level == .hidden ? nil : RenderablePOI(poi: poi, level: level)
        }
    }
    
    /// Helper para que la vista no tenga que decidir visibilidad de títulos.
    func titleVisibility(for level: RevealLevel) -> Visibility {
        switch level {
        case .labeled: return .visible
        default: return .hidden
        }
    }
    
    // MARK: - Private
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
    
    private func cameraToShow(from s: HomeSelection) -> MapCamera {
        // 1) Si ya hay sede seleccionada, centra en la sede
        if let venue = s.selectedVenue {
            return MapCamera(centerCoordinate: venue.center, distance: 3000, heading: 0, pitch: 0)
        }
        
        // 2) En flujo de lista, prioriza la selección actual del carrusel
        if s.showVenueList {
            if let venue = s.positionedVenue {
                return MapCamera(centerCoordinate: venue.center, distance: 9000, heading: 0, pitch: 35)
            }
            if let city = s.selectedCity ?? s.positionedCity ?? s.cities.first {
                return MapCamera(centerCoordinate: city.center, distance: 500000, heading: 0, pitch: 10)
            }
            if let venue = s.venues.first {
                return MapCamera(centerCoordinate: venue.center, distance: 9000, heading: 0, pitch: 35)
            }
        }
        
        // 3) Pantalla inicial (hero)
        return getRandomCamera()
    }
}

//
//  Venue.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import Foundation
import CoreLocation
import SwiftUI

struct Venue: Identifiable, Equatable {
    let id = UUID()
    
    let name: String
    let city: City                     // ← NUEVO: ciudad a la que pertenece la sede
    let center: CLLocationCoordinate2D
    let pathImage: [VenuePath]
    let accessibilityDescription: String
    let accessibilityLabel: String
    
    var pois: [VenuePOI]
}

extension Venue {
    static func == (lhs: Venue, rhs: Venue) -> Bool {
        lhs.id == rhs.id
    }
}

struct VenuePath {
    let pathImage: String
    let floor: Int
    let imageRotation: CGFloat
}

struct VenuePOI: Identifiable {
    let id = UUID()
    
    let center: CLLocationCoordinate2D
    let floor: Int
    let type: pointOfInterest
}

enum pointOfInterest: String, CaseIterable {
    case medicalKit
    case parking
    case stails
    case access
    case accessWheelchair
    case elevator
    case food
    case enfermy
    case atm
    case bathroom
    case familyBathroom
    case elevatorWheelchair
    case customerService
    case other
    
    //Nombre a mostrar
    var displayName: String {
        NSLocalizedString("poi.\(rawValue)", comment: "Point of interest display name")
    }
    
    //Icono del punto
    var icon: String {
        switch self {
        case .stails:
            "stairs"
        case .access:
            "door.left.hand.open"
        case .accessWheelchair:
            "wheelchair"
        case .elevator:
            "arrow.up.arrow.down"
        case .food:
            "fork.knife"
        case .enfermy:
            "heart.fill"
        case .atm:
            "dollarsign"
        case .bathroom:
            "figure.stand.dress.line.vertical.figure"
        case .familyBathroom:
            "figure.2.and.child.holdinghands"
        case .elevatorWheelchair:
            "wheelchair"
        case .customerService:
            "gearshape.fill"
        case .other:
            "ellipsis"
        case .medicalKit:
            "plus"
        case .parking:
            "e.circle"
        }
    }
    
    //Color del punto
    var color: Color {
        switch self {
        case .stails:
                .gray
        case .access:
                .gray
        case .accessWheelchair:
                .blue
        case .elevator:
                .blue
        case .food:
                .orange
        case .enfermy:
                .pink
        case .atm:
                .green
        case .bathroom:
                .brown
        case .familyBathroom:
                .indigo
        case .elevatorWheelchair:
                .mint
        case .customerService:
                .cyan
        case .other:
                .gray
        case .medicalKit:
                .red
        case .parking:
                .blue
        }
    }
}

extension Venue {
    // Conjunto de venues de prueba
    static let mocks: [Venue] = [
        .estadioBBVA,
        .estadioUniversitario,
        .arenaMonterrey,
        .estadioAzteca,
        .estadioAkron
    ]
    
    // MARK: - Monterrey
    static let estadioBBVA = Venue(
        name: "Estadio BBVA",
        city: .mty,
        center: .init(latitude: 25.6689, longitude: -100.2451),
        pathImage: [
            VenuePath(pathImage: "BBVApath", floor: 0, imageRotation: 96.55)
        ],
        accessibilityDescription: "Estadio con accesos y servicios accesibles.",
        accessibilityLabel: "Estadio BBVA",
        pois: [
            VenuePOI(center: .init(latitude: 25.668826, longitude: -100.243584), floor: 0, type: .access),
            VenuePOI(center: .init(latitude: 25.668736, longitude: -100.245184), floor: 0, type: .access),
            VenuePOI(center: .init(latitude: 25.669111, longitude: -100.245771), floor: 0, type: .parking),
            VenuePOI(center: .init(latitude: 25.669300, longitude: -100.244900), floor: 0, type: .food),
            VenuePOI(center: .init(latitude: 25.669020, longitude: -100.244500), floor: 0, type: .bathroom),
            VenuePOI(center: .init(latitude: 25.668980, longitude: -100.244620), floor: 0, type: .bathroom)
        ]
    )
    
    static let estadioUniversitario = Venue(
        name: "Estadio Universitario",
        city: .mty,
        center: .init(latitude: 25.7253, longitude: -100.3131),
        pathImage: [
            VenuePath(pathImage: "UNIpath", floor: 0, imageRotation: 0)
        ],
        accessibilityDescription: "Estadio con áreas de comida y elevadores.",
        accessibilityLabel: "Estadio Universitario",
        pois: [
            VenuePOI(center: .init(latitude: 25.725100, longitude: -100.312900), floor: 0, type: .access),
            VenuePOI(center: .init(latitude: 25.725500, longitude: -100.313400), floor: 0, type: .accessWheelchair),
            VenuePOI(center: .init(latitude: 25.725700, longitude: -100.313000), floor: 0, type: .food),
            VenuePOI(center: .init(latitude: 25.725250, longitude: -100.313550), floor: 0, type: .elevator),
            VenuePOI(center: .init(latitude: 25.725420, longitude: -100.313300), floor: 0, type: .familyBathroom)
        ]
    )
    
    static let arenaMonterrey = Venue(
        name: "Arena Monterrey",
        city: .mty,
        center: .init(latitude: 25.6866, longitude: -100.2831),
        pathImage: [
            VenuePath(pathImage: "ArenaPath", floor: 0, imageRotation: 0)
        ],
        accessibilityDescription: "Arena techada con múltiples servicios.",
        accessibilityLabel: "Arena Monterrey",
        pois: [
            VenuePOI(center: .init(latitude: 25.686700, longitude: -100.283000), floor: 0, type: .access),
            VenuePOI(center: .init(latitude: 25.686550, longitude: -100.283200), floor: 0, type: .customerService),
            VenuePOI(center: .init(latitude: 25.686620, longitude: -100.283300), floor: 0, type: .medicalKit),
            VenuePOI(center: .init(latitude: 25.686720, longitude: -100.283150), floor: 0, type: .bathroom),
            VenuePOI(center: .init(latitude: 25.686780, longitude: -100.283060), floor: 0, type: .bathroom)
        ]
    )
    
    // MARK: - CDMX
    static let estadioAzteca = Venue(
        name: "Estadio Azteca",
        city: .cdmx,
        center: .init(latitude: 19.3029, longitude: -99.1505),
        pathImage: [
            VenuePath(pathImage: "AztecaPath", floor: 0, imageRotation: 0)
        ],
        accessibilityDescription: "Estadio con amplias zonas y servicios.",
        accessibilityLabel: "Estadio Azteca",
        pois: [
            VenuePOI(center: .init(latitude: 19.303200, longitude: -99.151000), floor: 0, type: .access),
            VenuePOI(center: .init(latitude: 19.302600, longitude: -99.150100), floor: 0, type: .parking),
            VenuePOI(center: .init(latitude: 19.303000, longitude: -99.150600), floor: 0, type: .food),
            VenuePOI(center: .init(latitude: 19.303050, longitude: -99.150400), floor: 0, type: .bathroom),
            VenuePOI(center: .init(latitude: 19.302950, longitude: -99.150300), floor: 0, type: .bathroom)
        ]
    )
    
    // MARK: - Guadalajara
    static let estadioAkron = Venue(
        name: "Estadio Akron",
        city: .gdl,
        center: .init(latitude: 20.6735, longitude: -103.4632),
        pathImage: [
            VenuePath(pathImage: "AkronPath", floor: 0, imageRotation: 0)
        ],
        accessibilityDescription: "Estadio moderno con accesibilidad.",
        accessibilityLabel: "Estadio Akron",
        pois: [
            VenuePOI(center: .init(latitude: 20.673700, longitude: -103.463000), floor: 0, type: .access),
            VenuePOI(center: .init(latitude: 20.673900, longitude: -103.463300), floor: 0, type: .accessWheelchair),
            VenuePOI(center: .init(latitude: 20.673800, longitude: -103.463100), floor: 0, type: .food),
            VenuePOI(center: .init(latitude: 20.673650, longitude: -103.463250), floor: 0, type: .elevator),
            VenuePOI(center: .init(latitude: 20.673600, longitude: -103.463150), floor: 0, type: .familyBathroom)
        ]
    )
}

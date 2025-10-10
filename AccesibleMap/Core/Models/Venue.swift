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
    case oficialStore
    case atm
    case manBathroom
    case womanBathroom
    case familyBathroom
    case elevatorWheelchair
    case customerService
    case other
    
    //Nombre a mostrar
    var displayName: String {
        switch self {
        case .stails:
            "Escaleras"
        case .access:
            "Acceso"
        case .accessWheelchair:
            "Acceso para personas con discapacidad"
        case .elevator:
            "Elevador"
        case .food:
            "Restaurantes"
        case .enfermy:
            "Enfermeria"
        case .oficialStore:
            "Tienda oficial"
        case .atm:
            "Cajero"
        case .manBathroom:
            "Baño hombres"
        case .womanBathroom:
            "Baño mujeres"
        case .familyBathroom:
            "Baño familiare"
        case .elevatorWheelchair:
            "Elevador para personas con discapacidad"
        case .customerService:
            "Atención al cliente"
        case .other:
            "otros"
        case .medicalKit:
            "Primeros aúxilios"
        case .parking:
            "Estacionamiento"
        }
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
        case .oficialStore:
            "bag.fill"
        case .atm:
            "dollarsign"
        case .manBathroom:
            "figure.stand"
        case .womanBathroom:
            "figure.stand.dress"
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
        case .oficialStore:
                .cyan
        case .atm:
                .green
        case .manBathroom:
                .brown
        case .womanBathroom:
                .purple
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
        .aeropuertoMTY,
        .arenaMonterrey
    ]
    
    // MARK: - Individuos
    static let estadioBBVA = Venue(
        name: "Estadio BBVA",
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
            VenuePOI(center: .init(latitude: 25.669020, longitude: -100.244500), floor: 0, type: .manBathroom),
            VenuePOI(center: .init(latitude: 25.668980, longitude: -100.244620), floor: 0, type: .womanBathroom)
        ]
    )
    
    static let estadioUniversitario = Venue(
        name: "Estadio Universitario",
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
    
    static let aeropuertoMTY = Venue(
        name: "Aeropuerto MTY",
        center: .init(latitude: 25.7785, longitude: -100.1060),
        pathImage: [
            VenuePath(pathImage: "MTYAirportPath", floor: 0, imageRotation: 0)
        ],
        accessibilityDescription: "Terminal con elevadores y atención a clientes.",
        accessibilityLabel: "Aeropuerto de Monterrey",
        pois: [
            VenuePOI(center: .init(latitude: 25.778700, longitude: -100.106200), floor: 0, type: .customerService),
            VenuePOI(center: .init(latitude: 25.778300, longitude: -100.105900), floor: 0, type: .elevatorWheelchair),
            VenuePOI(center: .init(latitude: 25.778900, longitude: -100.106400), floor: 0, type: .atm),
            VenuePOI(center: .init(latitude: 25.778600, longitude: -100.106100), floor: 0, type: .food),
            VenuePOI(center: .init(latitude: 25.778450, longitude: -100.106050), floor: 0, type: .access)
        ]
    )
    
    static let arenaMonterrey = Venue(
        name: "Arena Monterrey",
        center: .init(latitude: 25.6866, longitude: -100.2831),
        pathImage: [
            VenuePath(pathImage: "ArenaPath", floor: 0, imageRotation: 0)
        ],
        accessibilityDescription: "Arena techada con múltiples servicios.",
        accessibilityLabel: "Arena Monterrey",
        pois: [
            VenuePOI(center: .init(latitude: 25.686700, longitude: -100.283000), floor: 0, type: .access),
            VenuePOI(center: .init(latitude: 25.686550, longitude: -100.283200), floor: 0, type: .oficialStore),
            VenuePOI(center: .init(latitude: 25.686620, longitude: -100.283300), floor: 0, type: .medicalKit),
            VenuePOI(center: .init(latitude: 25.686720, longitude: -100.283150), floor: 0, type: .womanBathroom),
            VenuePOI(center: .init(latitude: 25.686780, longitude: -100.283060), floor: 0, type: .manBathroom)
        ]
    )
}

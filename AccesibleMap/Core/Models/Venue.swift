//
//  Venue.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import Foundation
import CoreLocation
import SwiftUI

struct Venue: Identifiable {
    let id = UUID()
    
    let name: String
    let center: CLLocationCoordinate2D
    let pathImage: [VenuePath]
    let accessibilityDescription: String
    let accessibilityLabel: String
    
    var pois: [VenuePOI]
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

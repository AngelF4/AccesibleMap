//
//  City.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 10/10/25.
//

import Foundation
import CoreLocation
import SwiftUI

// 1) Nueva entidad de ciudad para el flujo Ciudad → Sede → POIs
enum City: String, CaseIterable, Identifiable {
    case cdmx, gdl, mty
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .cdmx: "Ciudad de México"
        case .gdl: "Guadalajara"
        case .mty: "Monterrey"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .cdmx:
            Color("PrincipalCDMX")
        case .gdl:
            Color("PrincipalGdl")
        case .mty:
            Color("PrincipalMty")
        }
    }
    var secondaryColor: Color {
        switch self {
        case .cdmx:
            Color("SecondaryCDMX")
        case .gdl:
            Color("SecondaryGdl")
        case .mty:
            Color("SecondaryMty")
        }
    }
    
    /// Centro aproximado de la ciudad para centrar la cámara.
    var center: CLLocationCoordinate2D {
        switch self {
        case .cdmx: .init(latitude: 19.432608, longitude: -99.133209)
        case .gdl:  .init(latitude: 20.659698, longitude: -103.349609)
        case .mty:  .init(latitude: 25.686613, longitude: -100.316116)
        }
    }
    
    /// Para ordenar consistentemente en el pager.
    var sortOrder: Int {
        switch self {
        case .cdmx: 0
        case .gdl:  1
        case .mty:  2
        }
    }
}

//
//  DecodersModels.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 15/10/25.
//

import Foundation
import CoreLocation

struct CoordinateDTO: Decodable {
    let latitude: Double
    let longitude: Double
    var coord: CLLocationCoordinate2D { .init(latitude: latitude, longitude: longitude) }
}
struct VenuePathDTO: Decodable {
    let pathImage: String
    let floor: Int
    let imageRotation: CGFloat
}
struct POIDTO: Decodable {
    let center: CoordinateDTO
    let floor: Int
    let type: String
}
struct VenueDTO: Decodable {
    let name: String
    let city: String
    let center: CoordinateDTO
    let pathImage: [VenuePathDTO]
    let accessibilityDescription: String
    let accessibilityLabel: String
    let pois: [POIDTO]
}

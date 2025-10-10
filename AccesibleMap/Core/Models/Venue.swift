//
//  Venue.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import Foundation
import CoreLocation

struct Venue: Identifiable, Codable, Hashable, Equatable {
    let id: UUID
    let name: String
    let category: String
    let address: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Venue {
    static let defaultVenues: [Venue] = [
        Venue(
            id: UUID(uuidString: "39d99782-e955-4669-beb4-9be07a6a3113")!,
            name: "BBVA Garza Sada",
            category: "Banco",
            address: "Av. Eugenio Garza Sada 427, Monterrey, N.L.",
            latitude: 25.643011,
            longitude: -100.289215
        ),
        Venue(
            id: UUID(uuidString: "0a088e48-7b0b-43ff-8bc2-179ed5fc8080")!,
            name: "Tecnológico de Monterrey",
            category: "Universidad",
            address: "Av. Eugenio Garza Sada Sur 2501, Monterrey, N.L.",
            latitude: 25.651972,
            longitude: -100.289925
        ),
        Venue(
            id: UUID(uuidString: "5480464b-27a2-4f8f-8f6f-7373057a9c30")!,
            name: "Museo MARCO",
            category: "Museo",
            address: "Juan Zuazua 655, Centro, Monterrey, N.L.",
            latitude: 25.664556,
            longitude: -100.309201
        ),
        Venue(
            id: UUID(uuidString: "aa2b09e9-60b0-4f20-a1ca-6be8c6b31170")!,
            name: "Parque Fundidora",
            category: "Parque",
            address: "Av. Fundidora y Adolfo Prieto S/N, Monterrey, N.L.",
            latitude: 25.678266,
            longitude: -100.284495
        )
    ]

    static var sample: Venue {
        defaultVenues.first!
    }
}

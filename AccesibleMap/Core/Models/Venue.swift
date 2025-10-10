//
//  Venue.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import Foundation
import MapKit

struct Venue: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    let address: String
    let city: String
    let category: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Venue {
    static let samples: [Venue] = [
        .init(
            id: UUID(uuidString: "1F2B9C26-0E82-4B61-8CF4-09C6B8FB86D7") ?? UUID(),
            name: "BBVA Bancomer Centro",
            description: "Sucursal accesible con rampas de acceso y elevadores disponibles.",
            latitude: 19.431997,
            longitude: -99.133203,
            address: "Av. Juárez 50, Centro Histórico",
            city: "Ciudad de México",
            category: "Banco"
        ),
        .init(
            id: UUID(uuidString: "0A7FB44E-5148-4734-A6A9-FA470457AF3D") ?? UUID(),
            name: "Hospital Ángeles",
            description: "Hospital con servicios especializados en accesibilidad.",
            latitude: 19.432972,
            longitude: -99.197792,
            address: "Av. Paseo de la Reforma 62, Juárez",
            city: "Ciudad de México",
            category: "Salud"
        ),
        .init(
            id: UUID(uuidString: "8E0A82C8-5085-4D9E-BE94-48A41C12F9DE") ?? UUID(),
            name: "Museo de Arte Moderno",
            description: "Museo con rutas accesibles y señalización táctil.",
            latitude: 19.425957,
            longitude: -99.186008,
            address: "Av. Paseo de la Reforma s/n, Bosque de Chapultepec",
            city: "Ciudad de México",
            category: "Cultura"
        )
    ]
}

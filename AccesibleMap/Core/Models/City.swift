//
//  City.swift
//  AccesibleMap
//
//  Created by OpenAI on 24/02/24.
//

import Foundation
import CoreLocation

struct City: Identifiable, Equatable {
    let id = UUID()

    let name: String
    let coordinate: CLLocationCoordinate2D
    let venues: [Venue]
}

extension City {
    static let cdmx = City(
        name: "CDMX",
        coordinate: .init(latitude: 19.432608, longitude: -99.133209),
        venues: [
            .estadioAzteca,
            .foroSol
        ]
    )

    static let guadalajara = City(
        name: "Guadalajara",
        coordinate: .init(latitude: 20.659699, longitude: -103.349609),
        venues: [
            .estadioAkron,
            .arenaVFG
        ]
    )

    static let monterrey = City(
        name: "Monterrey",
        coordinate: .init(latitude: 25.686613, longitude: -100.316116),
        venues: [
            .estadioBBVA,
            .estadioUniversitario,
            .aeropuertoMTY,
            .arenaMonterrey
        ]
    )

#if DEBUG
    static let mocks: [City] = [
        .cdmx,
        .guadalajara,
        .monterrey
    ]
#else
    static let mocks: [City] = [
        .monterrey
    ]
#endif
}


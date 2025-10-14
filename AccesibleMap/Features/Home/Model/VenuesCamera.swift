//
//  VenuesCamera.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 09/10/25.
//

import SwiftUI
import MapKit

class VenuesCamera {
    let cameras: [MapCamera] = [
        MapCamera(
            centerCoordinate: .init(
                latitude: 25.669122,
                longitude: -100.244362
            ),
            distance: 1200,
            heading: -30,
            pitch: 64
        ),
        // Estadio Universitario (UANL - Tigres)
        MapCamera(
            centerCoordinate: .init(
                latitude: 25.722516391227714,
                longitude: -100.31198463210087
            ),
            distance: 1200,
            heading: 15,
            pitch: 64
        ),
        MapCamera(
            centerCoordinate: .init(
                latitude: 20.681728,
                longitude: -103.462681
            ),
            distance: 1200,
            heading: 70,
            pitch: 64),
        // Estadio Mobil Super (Sultanes de Monterrey)
//        MapCamera(
//            centerCoordinate: .init(
//                latitude: 25.7181772058031,
//                longitude: -100.31563755707107
//            ),
//            distance: 1100,
//            heading: -20,
//            pitch: 64
//        ),
        // Estadio Borregos (ITESM)
        MapCamera(
            centerCoordinate: .init(
                latitude: 25.654429468749143,
                longitude: -100.28558285522575
            ),
            distance: 1200,
            heading: 0,
            pitch: 64
        ),
        //Estadio Azteca
        MapCamera(
            centerCoordinate: .init(latitude: 19.3029, longitude: -99.1505),
            distance: 1100,
            heading: -25,
            pitch: 64
        )
    ]
}

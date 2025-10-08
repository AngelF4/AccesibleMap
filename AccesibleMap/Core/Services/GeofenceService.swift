//
//  GeofenceService.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 07/10/25.
//

import Foundation
import CoreLocation
import SwiftUI

final class GeofenceService {
    let venueBBVA = Venue(
        name: "Estadio BBVA",
        center: .init(latitude: 25.669122, longitude: -100.244362),
        pathImage: [.init(pathImage: "BBVAPath", floor: 1, imageRotation: 96.55)],
        accessibilityDescription: "Marcador del estadio BBVA",
        accessibilityLabel: "Marcador del croquis del estadio BBVA",
        pois: [
            .init(
                center: .init(
                    latitude:  25.670199,
                    longitude: -100.244330
                ),
                floor: 1,
                type: .manBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.670170,
                    longitude: -100.244078
                ),
                floor: 1,
                type: .manBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.670093,
                    longitude: -100.243826
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.670190,
                    longitude: -100.244469
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.670161,
                    longitude: -100.244641
                ),
                floor: 1,
                type: .womanBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.670064,
                    longitude: -100.244947
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.669977,
                    longitude: -100.245070
                ),
                floor: 1,
                type: .elevatorWheelchair
            ),
            .init(
                center: .init(
                    latitude:  25.669875,
                    longitude: -100.245129
                ),
                floor: 1,
                type: .manBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.669769,
                    longitude: -100.245156
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.669668,
                    longitude: -100.245210
                ),
                floor: 1,
                type: .womanBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.669527,
                    longitude: -100.245253
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.669097,
                    longitude: -100.245333
                ),
                floor: 1,
                type: .manBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668981,
                    longitude: -100.245349
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.668652,
                    longitude: -100.245349
                ),
                floor: 1,
                type: .womanBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668478,
                    longitude: -100.245285
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.668386,
                    longitude: -100.245172
                ),
                floor: 1,
                type: .manBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668280,
                    longitude: -100.244861
                ),
                floor: 1,
                type: .familyBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668236,
                    longitude: -100.244679
                ),
                floor: 1,
                type: .manBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668242,
                    longitude: -100.244325
                ),
                floor: 1,
                type: .manBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668227,
                    longitude: -100.244072
                ),
                floor: 1,
                type: .familyBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668358,
                    longitude: -100.243622
                ),
                floor: 1,
                type: .manBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668595,
                    longitude: -100.243514
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.668537,
                    longitude: -100.243531
                ),
                floor: 1,
                type: .womanBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668672,
                    longitude: -100.243445
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.668798,
                    longitude: -100.243418
                ),
                floor: 1,
                type: .manBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.669228,
                    longitude: -100.243337
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.669373,
                    longitude: -100.243332
                ),
                floor: 1,
                type: .womanBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.669509,
                    longitude: -100.243391
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.669697,
                    longitude: -100.243429
                ),
                floor: 1,
                type: .manBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.669755,
                    longitude: -100.243466
                ),
                floor: 1,
                type: .enfermy
            ),
            .init(
                center: .init(
                    latitude:  25.669900,
                    longitude: -100.243600
                ),
                floor: 1,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.669982,
                    longitude: -100.243734
                ),
                floor: 1,
                type: .familyBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.669949,
                    longitude: -100.244121
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669973,
                    longitude: -100.244330
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669987,
                    longitude: -100.244700
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669774,
                    longitude: -100.244979
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669591,
                    longitude: -100.245038
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669509,
                    longitude: -100.245049
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669441,
                    longitude: -100.245049
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669363,
                    longitude: -100.245065
                ),
                floor: 1,
                type: .atm
            ),
            .init(
                center: .init(
                    latitude:  25.669252,
                    longitude: -100.245081
                ),
                floor: 1,
                type: .oficialStore
            ),
            .init(
                center: .init(
                    latitude:  25.669117,
                    longitude: -100.245102
                ),
                floor: 1,
                type: .enfermy
            ),
            .init(
                center: .init(
                    latitude:  25.669001,
                    longitude: -100.245135
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668899,
                    longitude: -100.245145
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668764,
                    longitude: -100.245161
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668454,
                    longitude: -100.245017
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668348,
                    longitude: -100.244732
                ),
                floor: 1,
                type: .other
            ),
            .init(
                center: .init(
                    latitude:  25.668338,
                    longitude: -100.244587
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668314,
                    longitude: -100.244421
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668353,
                    longitude: -100.243895
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668464,
                    longitude: -100.243751
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668604,
                    longitude: -100.243686
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668682,
                    longitude: -100.243638
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668948,
                    longitude: -100.243616
                ),
                floor: 1,
                type: .atm
            ),
            .init(
                center: .init(
                    latitude:  25.669373,
                    longitude: -100.243595
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669465,
                    longitude: -100.243590
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669567,
                    longitude: -100.243600
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669683,
                    longitude: -100.243611
                ),
                floor: 1,
                type: .customerService
            ),
            .init(
                center: .init(
                    latitude:  25.669784,
                    longitude: -100.243670
                ),
                floor: 1,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669847,
                    longitude: -100.243761
                ),
                floor: 1,
                type: .food
            ),
            .init(center: .init(latitude: 25.671172, longitude: -100.244590), floor: 1, type: .parking),
            .init(center: .init(latitude: 25.671482, longitude: -100.242804), floor: 1, type: .parking),
            .init(center: .init(latitude: 25.669180, longitude: -100.242627), floor: 1, type: .parking),
            .init(center: .init(latitude: 25.667594, longitude: -100.243700), floor: 1, type: .parking),
            .init(center: .init(latitude: 25.667188, longitude: -100.245271), floor: 1, type: .parking),
            .init(center: .init(latitude: 25.670248, longitude: -100.244349), floor: 1, type: .accessWheelchair),
            .init(center: .init(latitude: 25.670200, longitude: -100.243957), floor: 1, type: .access),
            .init(center: .init(latitude: 25.670026, longitude: -100.243517), floor: 1, type: .accessWheelchair),
            .init(center: .init(latitude: 25.669566, longitude: -100.243233), floor: 1, type: .access),
            .init(center: .init(latitude: 25.668362, longitude: -100.243437), floor: 1, type: .accessWheelchair),
            .init(center: .init(latitude: 25.668067, longitude: -100.244102), floor: 1, type: .access),
            .init(center: .init(latitude: 25.668150, longitude: -100.244805), floor: 1, type: .accessWheelchair),
            .init(center: .init(latitude: 25.668667, longitude: -100.245491), floor: 1, type: .access),
            .init(center: .init(latitude: 25.669881, longitude: -100.245325), floor: 1, type: .access),
            .init(center: .init(latitude: 25.670195, longitude: -100.244955), floor: 1, type: .access)
        ]
    )
}

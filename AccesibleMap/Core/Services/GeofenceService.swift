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
    var venues: [Venue]  {
        [
            venueBBVA,
            venueUANL,
            venueAkron
        ]
    }
    
    let venueBBVA = Venue(
        name: "Estadio BBVA",
        city: .mty,
        center: .init(latitude: 25.669122, longitude: -100.244362),
        pathImage: [.init(pathImage: "BBVAPath", floor: 0, imageRotation: 96.55)],
        accessibilityDescription: "Marcador del estadio BBVA",
        accessibilityLabel: "Marcador del croquis del estadio BBVA",
        pois: [
            .init(
                center: .init(
                    latitude:  25.670199,
                    longitude: -100.244330
                ),
                floor: 0,
                type: .bathroom
            ),
            .init(
                center: .init(
                    latitude:  25.670170,
                    longitude: -100.244078
                ),
                floor: 0,
                type: .bathroom
            ),
            .init(
                center: .init(
                    latitude:  25.670093,
                    longitude: -100.243826
                ),
                floor: 0,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.670190,
                    longitude: -100.244469
                ),
                floor: 0,
                type: .stails
            ),
//            .init(
//                center: .init(
//                    latitude:  25.670161,
//                    longitude: -100.244641
//                ),
//                floor: 0,
//                type: .wobathroom
//            ),
            .init(
                center: .init(
                    latitude:  25.670064,
                    longitude: -100.244947
                ),
                floor: 0,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.669977,
                    longitude: -100.245070
                ),
                floor: 0,
                type: .elevatorWheelchair
            ),
            .init(
                center: .init(
                    latitude:  25.669875,
                    longitude: -100.245129
                ),
                floor: 0,
                type: .bathroom
            ),
            .init(
                center: .init(
                    latitude:  25.669769,
                    longitude: -100.245156
                ),
                floor: 0,
                type: .stails
            ),
//            .init(
//                center: .init(
//                    latitude:  25.669668,
//                    longitude: -100.245210
//                ),
//                floor: 0,
//                type: .wobathroom
//            ),
            .init(
                center: .init(
                    latitude:  25.669527,
                    longitude: -100.245253
                ),
                floor: 0,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.669097,
                    longitude: -100.245333
                ),
                floor: 0,
                type: .bathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668981,
                    longitude: -100.245349
                ),
                floor: 0,
                type: .stails
            ),
//            .init(
//                center: .init(
//                    latitude:  25.668652,
//                    longitude: -100.245349
//                ),
//                floor: 0,
//                type: .wobathroom
//            ),
            .init(
                center: .init(
                    latitude:  25.668478,
                    longitude: -100.245285
                ),
                floor: 0,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.668386,
                    longitude: -100.245172
                ),
                floor: 0,
                type: .bathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668280,
                    longitude: -100.244861
                ),
                floor: 0,
                type: .familyBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668236,
                    longitude: -100.244679
                ),
                floor: 0,
                type: .bathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668242,
                    longitude: -100.244325
                ),
                floor: 0,
                type: .bathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668227,
                    longitude: -100.244072
                ),
                floor: 0,
                type: .familyBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668358,
                    longitude: -100.243622
                ),
                floor: 0,
                type: .bathroom
            ),
            .init(
                center: .init(
                    latitude:  25.668595,
                    longitude: -100.243514
                ),
                floor: 0,
                type: .stails
            ),
//            .init(
//                center: .init(
//                    latitude:  25.668537,
//                    longitude: -100.243531
//                ),
//                floor: 0,
//                type: .wobathroom
//            ),
            .init(
                center: .init(
                    latitude:  25.668672,
                    longitude: -100.243445
                ),
                floor: 0,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.668798,
                    longitude: -100.243418
                ),
                floor: 0,
                type: .bathroom
            ),
            .init(
                center: .init(
                    latitude:  25.669228,
                    longitude: -100.243337
                ),
                floor: 0,
                type: .stails
            ),
//            .init(
//                center: .init(
//                    latitude:  25.669373,
//                    longitude: -100.243332
//                ),
//                floor: 0,
//                type: .wobathroom
//            ),
            .init(
                center: .init(
                    latitude:  25.669509,
                    longitude: -100.243391
                ),
                floor: 0,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.669697,
                    longitude: -100.243429
                ),
                floor: 0,
                type: .bathroom
            ),
            .init(
                center: .init(
                    latitude:  25.669755,
                    longitude: -100.243466
                ),
                floor: 0,
                type: .enfermy
            ),
            .init(
                center: .init(
                    latitude:  25.669900,
                    longitude: -100.243600
                ),
                floor: 0,
                type: .stails
            ),
            .init(
                center: .init(
                    latitude:  25.669982,
                    longitude: -100.243734
                ),
                floor: 0,
                type: .familyBathroom
            ),
            .init(
                center: .init(
                    latitude:  25.669949,
                    longitude: -100.244121
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669973,
                    longitude: -100.244330
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669987,
                    longitude: -100.244700
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669774,
                    longitude: -100.244979
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669591,
                    longitude: -100.245038
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669509,
                    longitude: -100.245049
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669441,
                    longitude: -100.245049
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.669363,
                    longitude: -100.245065
                ),
                floor: 0,
                type: .atm
            ),
//            .init(
//                center: .init(
//                    latitude:  25.669252,
//                    longitude: -100.245081
//                ),
//                floor: 0,
//                type: .oficialStore
//            ),
            .init(
                center: .init(
                    latitude:  25.669117,
                    longitude: -100.245102
                ),
                floor: 0,
                type: .enfermy
            ),
            .init(
                center: .init(
                    latitude:  25.669001,
                    longitude: -100.245135
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668899,
                    longitude: -100.245145
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668764,
                    longitude: -100.245161
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668454,
                    longitude: -100.245017
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668348,
                    longitude: -100.244732
                ),
                floor: 0,
                type: .other
            ),
            .init(
                center: .init(
                    latitude:  25.668338,
                    longitude: -100.244587
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668314,
                    longitude: -100.244421
                ),
                floor: 0,
                type: .food
            ),
            .init(
                center: .init(
                    latitude:  25.668353,
                    longitude: -100.243895
                ),
                floor: 0,
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
            // Floor 1 — stairs duplicated from floor 0
            .init(center: .init(latitude: 25.670093, longitude: -100.243826), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.670190, longitude: -100.244469), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.670064, longitude: -100.244947), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.669769, longitude: -100.245156), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.669527, longitude: -100.245253), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.668981, longitude: -100.245349), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.668478, longitude: -100.245285), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.668595, longitude: -100.243514), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.668672, longitude: -100.243445), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.669228, longitude: -100.243337), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.669509, longitude: -100.243391), floor: 1, type: .stails),
            .init(center: .init(latitude: 25.669900, longitude: -100.243600), floor: 1, type: .stails),
            
            // Floor 1 — bathrooms (mirroring key floor 0 points)
            .init(center: .init(latitude: 25.670199, longitude: -100.244330), floor: 1, type: .bathroom),
//            .init(center: .init(latitude: 25.670161, longitude: -100.244641), floor: 1, type: .wobathroom),
            .init(center: .init(latitude: 25.669875, longitude: -100.245129), floor: 1, type: .bathroom),
//            .init(center: .init(latitude: 25.669668, longitude: -100.245210), floor: 1, type: .wobathroom),
            .init(center: .init(latitude: 25.668280, longitude: -100.244861), floor: 1, type: .familyBathroom),
            .init(center: .init(latitude: 25.668236, longitude: -100.244679), floor: 1, type: .bathroom),
            .init(center: .init(latitude: 25.668358, longitude: -100.243622), floor: 1, type: .bathroom),
//            .init(center: .init(latitude: 25.668537, longitude: -100.243531), floor: 1, type: .wobathroom),
            .init(center: .init(latitude: 25.668798, longitude: -100.243418), floor: 1, type: .bathroom),
//            .init(center: .init(latitude: 25.669373, longitude: -100.243332), floor: 1, type: .wobathroom),
            .init(center: .init(latitude: 25.669982, longitude: -100.243734), floor: 1, type: .familyBathroom),
            
            // Floor 1 — enfermería (mirror)
            .init(center: .init(latitude: 25.669755, longitude: -100.243466), floor: 1, type: .enfermy),
            .init(center: .init(latitude: 25.669117, longitude: -100.245102), floor: 1, type: .enfermy),
            
            // Floor 1 — atención al aficionado (ubicación oeste aproximada)
            .init(center: .init(latitude: 25.668950, longitude: -100.244900), floor: 1, type: .customerService),
            
            // Floor 1 — concesiones (distribuidas alrededor, basadas en puntos de piso 0)
            .init(center: .init(latitude: 25.669949, longitude: -100.244121), floor: 1, type: .food),
            .init(center: .init(latitude: 25.669973, longitude: -100.244330), floor: 1, type: .food),
            .init(center: .init(latitude: 25.669987, longitude: -100.244700), floor: 1, type: .food),
            .init(center: .init(latitude: 25.669774, longitude: -100.244979), floor: 1, type: .food),
            .init(center: .init(latitude: 25.669591, longitude: -100.245038), floor: 1, type: .food),
            .init(center: .init(latitude: 25.669441, longitude: -100.245049), floor: 1, type: .food),
            .init(center: .init(latitude: 25.668454, longitude: -100.245017), floor: 1, type: .food),
            .init(center: .init(latitude: 25.668338, longitude: -100.244587), floor: 1, type: .food),
            .init(center: .init(latitude: 25.668314, longitude: -100.244421), floor: 1, type: .food),
            .init(center: .init(latitude: 25.668353, longitude: -100.243895), floor: 1, type: .food),
            .init(center: .init(latitude: 25.671172, longitude: -100.244590), floor: 0, type: .parking),
            .init(center: .init(latitude: 25.671482, longitude: -100.242804), floor: 0, type: .parking),
            .init(center: .init(latitude: 25.669180, longitude: -100.242627), floor: 0, type: .parking),
            .init(center: .init(latitude: 25.667594, longitude: -100.243700), floor: 0, type: .parking),
            .init(center: .init(latitude: 25.667188, longitude: -100.245271), floor: 0, type: .parking),
            .init(center: .init(latitude: 25.670248, longitude: -100.244349), floor: 0, type: .accessWheelchair),
            .init(center: .init(latitude: 25.670200, longitude: -100.243957), floor: 0, type: .access),
            .init(center: .init(latitude: 25.670026, longitude: -100.243517), floor: 0, type: .accessWheelchair),
            .init(center: .init(latitude: 25.669566, longitude: -100.243233), floor: 0, type: .access),
            .init(center: .init(latitude: 25.668362, longitude: -100.243437), floor: 0, type: .accessWheelchair),
            .init(center: .init(latitude: 25.668067, longitude: -100.244102), floor: 0, type: .access),
            .init(center: .init(latitude: 25.668150, longitude: -100.244805), floor: 0, type: .accessWheelchair),
            .init(center: .init(latitude: 25.668667, longitude: -100.245491), floor: 0, type: .access),
            .init(center: .init(latitude: 25.669881, longitude: -100.245325), floor: 0, type: .access),
            .init(center: .init(latitude: 25.670195, longitude: -100.244955), floor: 0, type: .access)
        ]
    )

    let venueUANL = Venue(
        name: "Estadio UANL",
        city: .mty,
        center: .init(latitude: 25.722516391227714, longitude: -100.31198463210087),
        pathImage: [],
        accessibilityDescription: "Estadio UANL",
        accessibilityLabel: "Estadio de futbol de la Universidad Autónoma de Nuevo León",
        pois: [
            .init(center: .init(latitude: 25.721437, longitude: -100.310214), floor: 0, type: .parking),
            .init(center: .init(latitude: 25.722792, longitude: -100.309737), floor: 0, type: .parking),
            .init(center: .init(latitude: 25.72294, longitude: -100.314879), floor: 0, type: .parking),
            .init(center: .init(latitude: 25.722095, longitude: -100.313536), floor: 0, type: .accessWheelchair),
            .init(center: .init(latitude: 25.721434, longitude: -100.311018), floor: 0, type: .accessWheelchair),
//            .init(center: .init(latitude: 25.72181, longitude: -100.312953), floor: 0, type: .oficialStore),
            .init(center: .init(latitude: 25.721751, longitude: -100.312878), floor: 0, type: .atm),
            .init(center: .init(latitude: 25.722479, longitude: -100.31328), floor: 0, type: .atm),
            .init(center: .init(latitude: 25.722687, longitude: -100.313271), floor: 0, type: .access),
            .init(center: .init(latitude: 25.722887, longitude: -100.313248), floor: 0, type: .access),
            .init(center: .init(latitude: 25.723245, longitude: -100.312914), floor: 0, type: .access),
            .init(center: .init(latitude: 25.723199, longitude: -100.312976), floor: 0, type: .access),
            .init(center: .init(latitude: 25.723633, longitude: -100.312365), floor: 0, type: .accessWheelchair),
            .init(center: .init(latitude: 25.723455, longitude: -100.311185), floor: 0, type: .accessWheelchair),
            .init(center: .init(latitude: 25.722935, longitude: -100.310833), floor: 0, type: .access),
            .init(center: .init(latitude: 25.72237, longitude: -100.310642), floor: 0, type: .accessWheelchair),
            .init(center: .init(latitude: 25.722119, longitude: -100.310692), floor: 0, type: .access),
            .init(center: .init(latitude: 25.721578, longitude: -100.311273), floor: 0, type: .access),
            .init(center: .init(latitude: 25.721472, longitude: -100.312673), floor: 0, type: .accessWheelchair),
            .init(center: .init(latitude: 25.722261, longitude: -100.313238), floor: 0, type: .access),
            .init(center: .init(latitude: 25.7229, longitude: -100.313103), floor: 0, type: .enfermy),
            .init(center: .init(latitude: 25.722621, longitude: -100.310732), floor: 0, type: .enfermy),
//            .init(center: .init(latitude: 25.722736, longitude: -100.313017), floor: 0, type: .oficialStore),
//            .init(center: .init(latitude: 25.723126, longitude: -100.312827), floor: 0, type: .oficialStore),
//            .init(center: .init(latitude: 25.723501, longitude: -100.312664), floor: 0, type: .oficialStore),
//            .init(center: .init(latitude: 25.722484, longitude: -100.310959), floor: 0, type: .oficialStore),
//            .init(center: .init(latitude: 25.721966, longitude: -100.311136), floor: 0, type: .oficialStore),
            
        ])
    
    let venueAkron = Venue(
        name: "Estadio Akron",
        city: .gdl,
        center: .init(latitude: 20.681728, longitude: -103.462681),
        pathImage: [],
        accessibilityDescription: "Estadio Akron",
        accessibilityLabel: "Estadio de futbon Akron, casa del equipo Chivas Guadalajara",
        pois: [
            .init(center: .init(latitude: 20.682867, longitude: -103.466522), floor: 0, type: .parking),
            .init(center: .init(latitude: 20.682423, longitude: -103.463728), floor: 0, type: .access),
            .init(center: .init(latitude: 20.681384, longitude: -103.46376), floor: 0, type: .access),
            .init(center: .init(latitude: 20.680515, longitude: -103.462899), floor: 0, type: .access),
            .init(center: .init(latitude: 20.682891, longitude: -103.462085), floor: 0, type: .access),
            
        ])
}

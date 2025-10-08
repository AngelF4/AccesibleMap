//
//  poisBBVA.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 07/10/25.
//

import Foundation
import CoreLocation

class PoisBBVA {
    
    init() {}
    
    // POIs planta baja (aprox. según diagrama)
//    var bbvaPlantaBajaPOIs: [VenuePOI] {
//        return [
//        // Accesos perimetrales P1–P10
//        .init(name: "Acceso P1", center: at(110), floor: piso, type: .access),
//        .init(name: "Acceso P2", center: at(130), floor: piso, type: .access),
//        .init(name: "Acceso P3", center: at(210), floor: piso, type: .access),
//        .init(name: "Acceso P4", center: at(235), floor: piso, type: .access),
//        .init(name: "Acceso P5", center: at(260), floor: piso, type: .access),
//        .init(name: "Acceso P6", center: at(285), floor: piso, type: .access),
//        .init(name: "Acceso P7", center: at(310), floor: piso, type: .access),
//        .init(name: "Acceso P8", center: at(340), floor: piso, type: .access),
//        .init(name: "Acceso P9", center: at(20),  floor: piso, type: .access),
//        .init(name: "Acceso P10",center: at(70),  floor: piso, type: .access),
//        
//        // Accesos para discapacidad cercanos a P5, P7, P9, P1
//        .init(name: "Acceso Discapacidad Norte-Oeste", center: at(300, 105), floor: piso, type: .accessWheelchair),
//        .init(name: "Acceso Discapacidad Norte",       center: at(0,   105), floor: piso, type: .accessWheelchair),
//        .init(name: "Acceso Discapacidad Oriente",     center: at(90,  105), floor: piso, type: .accessWheelchair),
//        .init(name: "Acceso Discapacidad Sur",         center: at(180, 105), floor: piso, type: .accessWheelchair),
//        
//        // Escaleras distribuidas
//        .init(name: "Escaleras ES1",  center: at(150, 95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES2",  center: at(170, 95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES3",  center: at(200, 95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES4",  center: at(225, 95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES5",  center: at(245, 95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES6",  center: at(265, 95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES7",  center: at(285, 95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES8",  center: at(305, 95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES9",  center: at(330, 95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES10", center: at(350, 95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES11", center: at(20,  95), floor: piso, type: .stails),
//        .init(name: "Escaleras ES12", center: at(40,  95), floor: piso, type: .stails),
//        
//        // Concesiones (alimentos)
//        .init(name: "Concesión Poniente Baja", center: at(200, 85), floor: piso, type: .food),
//        .init(name: "Concesión Sur-Poniente",  center: at(160, 85), floor: piso, type: .food),
//        .init(name: "Concesión Sur-Oriente",   center: at(20,  85), floor: piso, type: .food),
//        .init(name: "Concesión Oriente Baja",  center: at(340, 85), floor: piso, type: .food),
//        .init(name: "Concesión Norte-Oriente", center: at(300, 85), floor: piso, type: .food),
//        
//        // Enfermería / Primeros auxilios
//        .init(name: "Enfermería Sur-Poniente", center: at(175, 80), floor: piso, type: .enfermy),
//        .init(name: "Enfermería Norte-Oriente",center: at(320, 80), floor: piso, type: .enfermy),
//        
//        // Tienda oficial
//        .init(name: "Tienda Rayados", center: at(120, 90), floor: piso, type: .oficialStore),
//        
//        // Cajeros
//        .init(name: "Cajero Sur",     center: at(145, 88), floor: piso, type: .atm),
//        .init(name: "Cajero Oriente", center: at(5,   88), floor: piso, type: .atm),
//        
//        // Baños
//        .init(name: "Baño Hombres Poniente", center: at(230, 88), floor: piso, type: .manBathroom),
//        .init(name: "Baño Hombres Norte",    center: at(320, 88), floor: piso, type: .manBathroom),
//        .init(name: "Baño Mujeres Sur",      center: at(155, 88), floor: piso, type: .womanBathroom),
//        .init(name: "Baño Mujeres Norte",    center: at(340, 88), floor: piso, type: .womanBathroom),
//        .init(name: "Baño Familiar Oriente", center: at(25,  88), floor: piso, type: .familyBathroom),
//        
//        // Elevador exclusivo discapacidad
//        .init(name: "Elevador Accesible Sur",    center: at(170, 78), floor: piso, type: .elevatorWheelchair),
//        .init(name: "Elevador Accesible Oriente",center: at(355, 78), floor: piso, type: .elevatorWheelchair),
//        
//        // Atención al aficionado / cliente
//        .init(name: "Atención al Aficionado", center: at(140, 82), floor: piso, type: .customerService),
//        
//        // Operaciones / otros
//        .init(name: "Operaciones Sur-Oriente", center: at(125, 82), floor: piso, type: .other)
//    ]
//    }
    
    // Centro del estadio
    let bbvaCenter = CLLocationCoordinate2D(latitude: 25.669180, longitude: -100.244614)
    
    // Utilidad: offset por bearing (grados) y distancia (m)
    func offset(from origin: CLLocationCoordinate2D, bearing degrees: Double, distance meters: Double) -> CLLocationCoordinate2D {
        let R = 6_371_000.0
        let δ = meters / R
        let θ = degrees * .pi / 180
        let φ1 = origin.latitude * .pi / 180
        let λ1 = origin.longitude * .pi / 180
        
        let φ2 = asin( sin(φ1)*cos(δ) + cos(φ1)*sin(δ)*cos(θ) )
        let λ2 = λ1 + atan2( sin(θ)*sin(δ)*cos(φ1), cos(δ) - sin(φ1)*sin(φ2) )
        
        return CLLocationCoordinate2D(latitude: φ2 * 180 / .pi, longitude: λ2 * 180 / .pi)
    }
    
    // Conveniencias
    func at(_ bearing: Double, _ r: Double = 115) -> CLLocationCoordinate2D {
        offset(from: bbvaCenter, bearing: bearing, distance: r)
    }
    let piso = 0
    
    
}

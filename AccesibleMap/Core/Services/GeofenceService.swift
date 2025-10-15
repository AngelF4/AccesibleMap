//
//  GeofenceService.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 07/10/25.
//


import Foundation
import CoreLocation
import SwiftUI

private enum VenueLoader {
    static func loadAllFromBundle() -> [Venue] {
        if let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil), !urls.isEmpty {
            var out: [Venue] = []
            for url in urls {
                if let v = loadVenue(at: url) { out.append(v) }
            }
#if DEBUG
            print("VenueLoader: Loaded \(out.count) venues from bundle root (no Venues/ subdir)")
#endif
            return out
        }
        
#if DEBUG
        print("VenueLoader: No JSON files found in bundle")
#endif
        return []
    }
    
    private static func loadVenue(at url: URL) -> Venue? {
        do {
            let data = try Data(contentsOf: url)
            let dto = try JSONDecoder().decode(VenueDTO.self, from: data)
            return map(dto)
        } catch {
            print("VenueLoader error decoding \(url.lastPathComponent): \(error)")
            return nil
        }
    }
    
    private static func map(_ v: VenueDTO) -> Venue? {
        guard let city = City(code: v.city) else { return nil }
        let paths: [VenuePath] = v.pathImage.map { .init(pathImage: $0.pathImage, floor: $0.floor, imageRotation: $0.imageRotation) }
        let pois: [VenuePOI] = v.pois.compactMap { (poi) -> VenuePOI? in
            guard let kind = pointOfInterest(rawValue: poi.type) else { return nil }
            return .init(center: poi.center.coord, floor: poi.floor, type: kind)
        }
        return Venue(
            name: v.name,
            city: city,
            center: v.center.coord,
            pathImage: paths,
            accessibilityDescription: v.accessibilityDescription,
            accessibilityLabel: v.accessibilityLabel,
            pois: pois
        )
    }
}

final class GeofenceService {
    var venues: [Venue]  {
        // 1) Intenta cargar desde /Venues/*.json en el bundle
        let fromJSON = VenueLoader.loadAllFromBundle()
        if !fromJSON.isEmpty { return fromJSON }
        
        // 2) Fallback a los venues embebidos (desarrollo)
        return [
            venueBBVA,
            //            venueUANL,
            //            venueAkron,
            //            venueAzteca
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
            .init(center: .init(latitude: 25.670199, longitude: -100.244330), floor: 0, type: .bathroom),
            .init(center: .init(latitude: 25.670170, longitude: -100.244078), floor: 0, type: .bathroom),
            .init(center: .init(latitude: 25.670093, longitude: -100.243826), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.670190, longitude: -100.244469), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.670064, longitude: -100.244947), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.669977, longitude: -100.245070), floor: 0, type: .elevatorWheelchair),
            .init(center: .init(latitude: 25.669875, longitude: -100.245129), floor: 0, type: .bathroom),
            .init(center: .init(latitude: 25.669769, longitude: -100.245156), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.669527, longitude: -100.245253), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.669097, longitude: -100.245333), floor: 0, type: .bathroom),
            .init(center: .init(latitude: 25.668981, longitude: -100.245349), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.668478, longitude: -100.245285), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.668386, longitude: -100.245172), floor: 0, type: .bathroom),
            .init(center: .init(latitude: 25.668280, longitude: -100.244861), floor: 0, type: .familyBathroom),
            .init(center: .init(latitude: 25.668236, longitude: -100.244679), floor: 0, type: .bathroom),
            .init(center: .init(latitude: 25.668242, longitude: -100.244325), floor: 0, type: .bathroom),
            .init(center: .init(latitude: 25.668227, longitude: -100.244072), floor: 0, type: .familyBathroom),
            .init(center: .init(latitude: 25.668358, longitude: -100.243622), floor: 0, type: .bathroom),
            .init(center: .init(latitude: 25.668595, longitude: -100.243514), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.668672, longitude: -100.243445), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.668798, longitude: -100.243418), floor: 0, type: .bathroom),
            .init(center: .init(latitude: 25.669228, longitude: -100.243337), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.669509, longitude: -100.243391), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.669697, longitude: -100.243429), floor: 0, type: .bathroom),
            .init(center: .init(latitude: 25.669755, longitude: -100.243466), floor: 0, type: .enfermy),
            .init(center: .init(latitude: 25.669900, longitude: -100.243600), floor: 0, type: .stails),
            .init(center: .init(latitude: 25.669982, longitude: -100.243734), floor: 0, type: .familyBathroom),
            .init(center: .init(latitude: 25.669949, longitude: -100.244121), floor: 0, type: .food),
            .init(center: .init(latitude: 25.669973, longitude: -100.244330), floor: 0, type: .food),
            .init(center: .init(latitude: 25.669987, longitude: -100.244700), floor: 0, type: .food),
            .init(center: .init(latitude: 25.669774, longitude: -100.244979), floor: 0, type: .food),
            .init(center: .init(latitude: 25.669591, longitude: -100.245038), floor: 0, type: .food),
            .init(center: .init(latitude: 25.669509, longitude: -100.245049), floor: 0, type: .food),
            .init(center: .init(latitude: 25.669441, longitude: -100.245049), floor: 0, type: .food),
            .init(center: .init(latitude: 25.669363, longitude: -100.245065), floor: 0, type: .atm),
            .init(center: .init(latitude: 25.669117, longitude: -100.245102), floor: 0, type: .enfermy),
            .init(center: .init(latitude: 25.669001, longitude: -100.245135), floor: 0, type: .food),
            .init(center: .init(latitude: 25.668899, longitude: -100.245145), floor: 0, type: .food),
            .init(center: .init(latitude: 25.668764, longitude: -100.245161), floor: 0, type: .food),
            .init(center: .init(latitude: 25.668454, longitude: -100.245017), floor: 0, type: .food),
            .init(center: .init(latitude: 25.668348, longitude: -100.244732), floor: 0, type: .other),
            .init(center: .init(latitude: 25.668338, longitude: -100.244587), floor: 0, type: .food),
            .init(center: .init(latitude: 25.668314, longitude: -100.244421), floor: 0, type: .food),
            .init(center: .init(latitude: 25.668353, longitude: -100.243895), floor: 0, type: .food),
            .init(center: .init(latitude: 25.668464, longitude: -100.243751), floor: 1, type: .food),
            .init(center: .init(latitude: 25.668604, longitude: -100.243686), floor: 1, type: .food),
            .init(center: .init(latitude: 25.668682, longitude: -100.243638), floor: 1, type: .food),
            .init(center: .init(latitude: 25.668948, longitude: -100.243616), floor: 1, type: .atm),
            .init(center: .init(latitude: 25.669373, longitude: -100.243595), floor: 1, type: .food),
            .init(center: .init(latitude: 25.669465, longitude: -100.243590), floor: 1, type: .food),
            .init(center: .init(latitude: 25.669567, longitude: -100.243600), floor: 1, type: .food),
            .init(center: .init(latitude: 25.669683, longitude: -100.243611), floor: 1, type: .customerService),
            .init(center: .init(latitude: 25.669784, longitude: -100.243670), floor: 1, type: .food),
            .init(center: .init(latitude: 25.669847, longitude: -100.243761), floor: 1, type: .food),
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
            .init(center: .init(latitude: 25.670199, longitude: -100.244330), floor: 1, type: .bathroom),
            .init(center: .init(latitude: 25.669875, longitude: -100.245129), floor: 1, type: .bathroom),
            .init(center: .init(latitude: 25.668280, longitude: -100.244861), floor: 1, type: .familyBathroom),
            .init(center: .init(latitude: 25.668236, longitude: -100.244679), floor: 1, type: .bathroom),
            .init(center: .init(latitude: 25.668358, longitude: -100.243622), floor: 1, type: .bathroom),
            .init(center: .init(latitude: 25.668798, longitude: -100.243418), floor: 1, type: .bathroom),
            .init(center: .init(latitude: 25.669982, longitude: -100.243734), floor: 1, type: .familyBathroom),
            .init(center: .init(latitude: 25.669755, longitude: -100.243466), floor: 1, type: .enfermy),
            .init(center: .init(latitude: 25.669117, longitude: -100.245102), floor: 1, type: .enfermy),
            .init(center: .init(latitude: 25.668950, longitude: -100.244900), floor: 1, type: .customerService),
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
    //
    //    let venueUANL = Venue(
    //        name: "Estadio UANL",
    //        city: .mty,
    //        center: .init(latitude: 25.722516391227714, longitude: -100.31198463210087),
    //        pathImage: [],
    //        accessibilityDescription: "Estadio UANL",
    //        accessibilityLabel: "Estadio de futbol de la Universidad Autónoma de Nuevo León",
    //        pois: [
    //            .init(center: .init(latitude: 25.721437, longitude: -100.310214), floor: 0, type: .parking),
    //            .init(center: .init(latitude: 25.722792, longitude: -100.309737), floor: 0, type: .parking),
    //            .init(center: .init(latitude: 25.72294, longitude: -100.314879), floor: 0, type: .parking),
    //            .init(center: .init(latitude: 25.722095, longitude: -100.313536), floor: 0, type: .accessWheelchair),
    //            .init(center: .init(latitude: 25.721434, longitude: -100.311018), floor: 0, type: .accessWheelchair),
    //            //            .init(center: .init(latitude: 25.72181, longitude: -100.312953), floor: 0, type: .oficialStore),
    //            .init(center: .init(latitude: 25.721751, longitude: -100.312878), floor: 0, type: .atm),
    //            .init(center: .init(latitude: 25.722479, longitude: -100.31328), floor: 0, type: .atm),
    //            .init(center: .init(latitude: 25.722687, longitude: -100.313271), floor: 0, type: .access),
    //            .init(center: .init(latitude: 25.722887, longitude: -100.313248), floor: 0, type: .access),
    //            .init(center: .init(latitude: 25.723245, longitude: -100.312914), floor: 0, type: .access),
    //            .init(center: .init(latitude: 25.723199, longitude: -100.312976), floor: 0, type: .access),
    //            .init(center: .init(latitude: 25.723633, longitude: -100.312365), floor: 0, type: .accessWheelchair),
    //            .init(center: .init(latitude: 25.723455, longitude: -100.311185), floor: 0, type: .accessWheelchair),
    //            .init(center: .init(latitude: 25.722935, longitude: -100.310833), floor: 0, type: .access),
    //            .init(center: .init(latitude: 25.72237, longitude: -100.310642), floor: 0, type: .accessWheelchair),
    //            .init(center: .init(latitude: 25.722119, longitude: -100.310692), floor: 0, type: .access),
    //            .init(center: .init(latitude: 25.721578, longitude: -100.311273), floor: 0, type: .access),
    //            .init(center: .init(latitude: 25.721472, longitude: -100.312673), floor: 0, type: .accessWheelchair),
    //            .init(center: .init(latitude: 25.722261, longitude: -100.313238), floor: 0, type: .access),
    //            .init(center: .init(latitude: 25.7229, longitude: -100.313103), floor: 0, type: .enfermy),
    //            .init(center: .init(latitude: 25.722621, longitude: -100.310732), floor: 0, type: .enfermy),
    //            //            .init(center: .init(latitude: 25.722736, longitude: -100.313017), floor: 0, type: .oficialStore),
    //            //            .init(center: .init(latitude: 25.723126, longitude: -100.312827), floor: 0, type: .oficialStore),
    //            //            .init(center: .init(latitude: 25.723501, longitude: -100.312664), floor: 0, type: .oficialStore),
    //            //            .init(center: .init(latitude: 25.722484, longitude: -100.310959), floor: 0, type: .oficialStore),
    //            //            .init(center: .init(latitude: 25.721966, longitude: -100.311136), floor: 0, type: .oficialStore),
    //
    //        ])
    //
    //    let venueAkron = Venue(
    //        name: "Estadio Akron",
    //        city: .gdl,
    //        center: .init(latitude: 20.681728, longitude: -103.462681),
    //        pathImage: [],
    //        accessibilityDescription: "Estadio Akron",
    //        accessibilityLabel: "Estadio de futbon Akron, casa del equipo Chivas Guadalajara",
    //        pois: [
    //            .init(center: .init(latitude: 20.682867, longitude: -103.466522), floor: 0, type: .parking),
    //            .init(center: .init(latitude: 20.682423, longitude: -103.463728), floor: 0, type: .access),
    //            .init(center: .init(latitude: 20.681384, longitude: -103.46376), floor: 0, type: .access),
    //            .init(center: .init(latitude: 20.680515, longitude: -103.462899), floor: 0, type: .access),
    //            .init(center: .init(latitude: 20.682891, longitude: -103.462085), floor: 0, type: .access),
    //            .init(center: .init(latitude: 20.68153, longitude: -103.463483), floor: 0, type: .customerService),
    //            .init(center: .init(latitude: 20.6819, longitude: -103.463496), floor: 0, type: .atm),
    //            .init(center: .init(latitude: 20.681212, longitude: -103.463392), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 20.680863, longitude: -103.463089), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 20.680797, longitude: -103.462245), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 20.681378, longitude: -103.461675), floor: 0, type: .familyBathroom),
    //            .init(center: .init(latitude: 20.681834, longitude: -103.461703), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 20.682072, longitude: -103.461868), floor: 0, type: .customerService),
    //            .init(center: .init(latitude: 20.682642, longitude: -103.462003), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 20.682529, longitude: -103.463214), floor: 0, type: .food),
    //            .init(center: .init(latitude: 20.682106, longitude: -103.463425), floor: 0, type: .food),
    //            .init(center: .init(latitude: 20.682144, longitude: -103.463669), floor: 0, type: .atm),
    //            // Floor 1 — servicios (ubicaciones aproximadas espejo del piso 0)
    //            .init(center: .init(latitude: 20.682529, longitude: -103.463214), floor: 1, type: .food),
    //            .init(center: .init(latitude: 20.682106, longitude: -103.463425), floor: 1, type: .food),
    //            .init(center: .init(latitude: 20.681212, longitude: -103.463392), floor: 1, type: .bathroom),
    //            .init(center: .init(latitude: 20.680863, longitude: -103.463089), floor: 1, type: .bathroom),
    //            .init(center: .init(latitude: 20.680797, longitude: -103.462245), floor: 1, type: .bathroom),
    //            .init(center: .init(latitude: 20.681378, longitude: -103.461675), floor: 1, type: .familyBathroom),
    //            .init(center: .init(latitude: 20.681834, longitude: -103.461703), floor: 1, type: .bathroom),
    //            .init(center: .init(latitude: 20.682642, longitude: -103.462003), floor: 1, type: .bathroom),
    //            .init(center: .init(latitude: 20.681530, longitude: -103.463483), floor: 1, type: .customerService),
    //            .init(center: .init(latitude: 20.682072, longitude: -103.461868), floor: 1, type: .customerService),
    //            .init(center: .init(latitude: 20.681900, longitude: -103.463496), floor: 1, type: .atm),
    //            .init(center: .init(latitude: 20.682144, longitude: -103.463669), floor: 1, type: .atm)
    //        ])
    //
    //    let venueAzteca = Venue(
    //        name: "Estadio Azteca",
    //        city: .cdmx,
    //        center: .init(latitude: 19.302941, longitude: -99.150484),
    //        pathImage: [],
    //        accessibilityDescription: "Estadio Azteca",
    //        accessibilityLabel: "Estadio Azteca, estadio de fútbol mexicano",
    //        pois: [
    //            .init(center: .init(latitude: 19.303391, longitude: -99.149305), floor: 0, type: .accessWheelchair),
    //            .init(center: .init(latitude: 19.302233, longitude: -99.14941), floor: 0, type: .accessWheelchair),
    //            .init(center: .init(latitude: 19.301812, longitude: -99.151368), floor: 0, type: .accessWheelchair),
    //            .init(center: .init(latitude: 19.303959, longitude: -99.151382), floor: 0, type: .accessWheelchair),
    //            .init(center: .init(latitude: 19.304222, longitude: -99.150748), floor: 0, type: .accessWheelchair),
    //            .init(center: .init(latitude: 19.304005, longitude: -99.150452), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 19.30393, longitude: -99.150122), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 19.303423, longitude: -99.149629), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 19.303166, longitude: -99.149577), floor: 0, type: .familyBathroom),
    //            .init(center: .init(latitude: 19.302482, longitude: -99.14965), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 19.302134, longitude: -99.149786), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 19.301963, longitude: -99.150438), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 19.301996, longitude: -99.150905), floor: 0, type: .familyBathroom),
    //            .init(center: .init(latitude: 19.303017, longitude: -99.151411), floor: 0, type: .bathroom),
    //            .init(center: .init(latitude: 19.302741, longitude: -99.151478), floor: 0, type: .enfermy),
    //            .init(center: .init(latitude: 19.3038, longitude: -99.149826), floor: 0, type: .enfermy),
    //            .init(center: .init(latitude: 19.302906, longitude: -99.149795), floor: 0, type: .customerService),
    //            .init(center: .init(latitude: 19.302649, longitude: -99.151321), floor: 0, type: .food),
    //            .init(center: .init(latitude: 19.303412, longitude: -99.15122), floor: 0, type: .food),
    //            .init(center: .init(latitude: 19.302978, longitude: -99.151272), floor: 0, type: .atm),
    //            .init(center: .init(latitude: 19.302472, longitude: -99.149843), floor: 0, type: .atm),
    //            .init(center: .init(latitude: 19.303682, longitude: -99.148457), floor: 0, type: .parking),
    //            .init(center: .init(latitude: 19.301709, longitude: -99.152248), floor: 0, type: .parking),
    //            .init(center: .init(latitude: 19.303788, longitude: -99.153448), floor: 0, type: .parking),
    //            .init(center: .init(latitude: 19.304591, longitude: -99.151643), floor: 0, type: .parking)
    //        ])
}

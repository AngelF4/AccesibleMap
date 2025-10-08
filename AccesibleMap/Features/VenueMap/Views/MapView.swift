//
//  MapView.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 07/10/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var locationVm: LocationViewModel
    @StateObject private var vm = MapViewModel()
    @State private var camera: MapCameraPosition = .automatic
    @State private var cameraInfo: MapCamera? = nil
    
    var body: some View {
        Map(position: $camera) {
            UserAnnotation()
            
            
            
            if let cam = cameraInfo {
                if cam.distance <= 2000 {
                    ForEach(vm.venues, id: \.id) { venue in
                        ForEach(venue.pois) { poi in
                            Marker(poi.type.displayName, systemImage: poi.type.icon, coordinate: poi.center)
                                .tint(poi.type.color)
                        }
                    }
                } else {
                    if cam.distance <= 4000 {
                        ForEach(vm.venues, id: \.id) { venue in
                            ForEach(venue.pois.filter({
                                $0.type == .parking ||
                                $0.type == .access ||
                                $0.type == .accessWheelchair
                            })) { poi in
                                Marker(poi.type.displayName, systemImage: poi.type.icon, coordinate: poi.center)
                                    .tint(poi.type.color)
                            }
                        }
                    }
                    ForEach(vm.venues, id: \.id) { venue in
                        Marker(venue.name, systemImage: "sportscourt", coordinate: venue.center)
                            .tint(Color.accentColor)
                    }
                }
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .onMapCameraChange(frequency: .continuous) { context in
            cameraInfo = context.camera
        }
        .mapStyle(.standard(
            elevation: .realistic,
            emphasis: .muted,
            pointsOfInterest: .including([.airport, .hotel]))
        )
        .onAppear {
            vm.loadVenues()
            locationVm.startUpdates()
            camera = .region(MKCoordinateRegion(
                center: .init(
                    latitude: locationVm.latitude ?? 25.669122,
                    longitude: locationVm.longitude ?? -100.244362
                ), span: .init(
                    latitudeDelta: 0.005,
                    longitudeDelta: 0.005
                ))
            )
        }
        .onDisappear {
            locationVm.stopUpdates()
        }
//        .overlay {
//            VStack(alignment: .leading, spacing: 6) {
//                if let cam = cameraInfo {
//                    Text("🎥 Camera:")
//                    Text("Pitch: \(cam.pitch, specifier: "%.1f")°")
//                    Text("Heading: \(cam.heading, specifier: "%.1f")°")
//                    Text("Altitude: \(cam.distance, specifier: "%.0f") m")
//                }
//            }
//            .font(.caption.monospaced())
//            .padding(12)
//            .background(.ultraThinMaterial)
//            .clipShape(RoundedRectangle(cornerRadius: 8))
//            .padding()
//            .frame(maxWidth: .infinity, alignment: .leading)
//        }
    }
}

#Preview {
    MapView(locationVm: LocationViewModel())
}

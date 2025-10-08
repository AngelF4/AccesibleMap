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
    
    @State private var selectedPOIId: UUID? = nil
    @State private var selectedPOI: VenuePOI? = nil
    @State private var showOnlyEssentials: Bool = true // acceso, acceso silla, estacionamiento
    @State private var selectedFloor: Int = 1
    
    private func filteredPOIs(for venue: Venue) -> [VenuePOI] {
        let base = venue.pois.filter { $0.floor == selectedFloor }
        if showOnlyEssentials {
            return base.filter { poi in
                poi.type == .parking || poi.type == .access || poi.type == .accessWheelchair
            }
        }
        return base
    }
    
    private func findPOI(by id: UUID) -> VenuePOI? {
        for venue in vm.venues {
            if let match = venue.pois.first(where: { $0.id == id }) { return match }
        }
        return nil
    }
    
    var body: some View {
        Map(position: $camera, selection: $selectedPOIId) {
            UserAnnotation()
            
            if let cam = cameraInfo {
                if cam.distance <= 2000 {
                    ForEach(vm.venues, id: \.id) { venue in
                        ForEach(filteredPOIs(for: venue)) { poi in
                            Marker(poi.type.displayName, systemImage: poi.type.icon, coordinate: poi.center)
                                .tint(poi.type.color)
                                .tag(poi.id)
                        }
                    }
                } else {
                    if cam.distance <= 4000 {
                        ForEach(vm.venues, id: \.id) { venue in
                            ForEach(filteredPOIs(for: venue)) { poi in
                                Marker(poi.type.displayName, systemImage: poi.type.icon, coordinate: poi.center)
                                    .tint(poi.type.color)
                                    .tag(poi.id)
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
        .onChange(of: selectedPOIId) { newValue in
            guard let id = newValue else { return }
            selectedPOI = findPOI(by: id)
            if selectedPOI != nil { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
        }
        .sheet(item: $selectedPOI) { poi in
            VStack(spacing: 12) {
                Text(poi.type.displayName)
                    .font(.headline)
                Text("Piso: \(poi.floor)")
                    .font(.subheadline)
                HStack {
                    Button("Cómo llegar") {
                        let placemark = MKPlacemark(coordinate: poi.center)
                        let item = MKMapItem(placemark: placemark)
                        item.name = poi.type.displayName
                        item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
                    }
                    Button("Cerrar") { selectedPOI = nil }
                }
            }
            .padding()
            .presentationDetents([.medium])
        }
        .safeAreaInset(edge: .top) {
            VStack {
                HStack(spacing: 8) {
                    // Piso
                    HStack(spacing: 6) {
                        Text("Piso")
                        Picker("Piso", selection: $selectedFloor) {
                            ForEach(1..<4, id: \.self) { piso in
                                Text("\(piso)").tag(piso)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 180)
                    }
                    .padding(8)
                    .glassEffect(.clear)
                    
                    
                    // Filtro rápido
                    Toggle(isOn: $showOnlyEssentials) {
                        Text("Esenciales")
                            .font(.callout)
                    }
                    .toggleStyle(.switch)
                    .padding(8)
                    .glassEffect(.clear)
                }
                HStack {
                    Spacer()
                    Button {
                        if let venue = vm.venues.first { // Puedes cambiar la heurística si manejas múltiples
                            camera = .region(MKCoordinateRegion(center: venue.center, span: .init(latitudeDelta: 0.004, longitudeDelta: 0.004)))
                        }
                    } label: {
                        Image(systemName: "sportscourt")
                            .padding(12)
                            .glassEffect(.regular, in: .circle)
                    }
                }
            }
            .padding([.top, .horizontal],8)
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
//                Button {
//                    if let userLat = locationVm.latitude, let userLon = locationVm.longitude {
//                        camera = .region(MKCoordinateRegion(center: .init(latitude: userLat, longitude: userLon), span: .init(latitudeDelta: 0.003, longitudeDelta: 0.003)))
//                    }
//                } label: {
//                    Image(systemName: "location.fill")
//                        .padding(10)
//                        .background(.ultraThinMaterial)
//                        .clipShape(Circle())
//                }

            }
            .padding(12)
        }
        .onAppear {
            vm.loadVenues()
            locationVm.startUpdates()
            selectedFloor = 1
            showOnlyEssentials = true
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

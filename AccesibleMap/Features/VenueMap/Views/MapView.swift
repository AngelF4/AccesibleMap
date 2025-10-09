//
//  MapView.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 07/10/25.
//

import SwiftUI
import MapKit

struct POIBadgeView: View {
    let poi: VenuePOI
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: poi.type.icon)
                .font(.system(size: 14, weight: .semibold))
            Text(poi.type.displayName)
                .font(.caption)
                .bold()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .foregroundStyle(.primary)
        .glassEffect(.regular)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(poi.type.color.opacity(0.9), lineWidth: 1)
        )
        .shadow(radius: 2)
    }
}

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
    
    private var cameraDistance: CLLocationDistance {
        cameraInfo?.distance ?? .greatestFiniteMagnitude
    }
    
    private var shouldShowPOIs: Bool {
        cameraDistance <= 4000
    }
    
    private var isVeryClose: Bool {
        cameraDistance <= 2000
    }
    
    private var visiblePOIs: [VenuePOI] {
        // Flatten venues to one array of filtered POIs to reduce nested generics in the body
        vm.venues.flatMap { venue in
            filteredPOIs(for: venue)
        }
    }
    
    var body: some View {
        Map(position: $camera, selection: $selectedPOIId) {
            UserAnnotation()
            
            if shouldShowPOIs {
                // Show POIs when close or mid distance; the visual used is the same but
                // we avoid duplicate branches to help the type-checker.
                ForEach(thinnedPOIs(from: visiblePOIs, distance: cameraDistance)) { poi in
                    let isStairs: Bool = poi.type == .stails || poi.type == .manBathroom || poi.type == .womanBathroom
                    var anchor: CGFloat {
                        if isStairs {
                            24
                        } else {
                            28
                        }
                    }
                    Annotation(isStairs ? "" : poi.type.displayName, coordinate: poi.center) {
                        Image(systemName: poi.type.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: anchor - 12, height: anchor - 12)
                            .frame(width: anchor, height: anchor)
                            .foregroundStyle(.white)
                            .background(poi.type.color.gradient.opacity(isStairs ? 0.9 : 1))
                            .clipShape(isStairs ? AnyShape(RoundedRectangle(cornerRadius: 4)) : AnyShape(Circle()))
                            .overlay {
                                if isStairs {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 2)
                                } else {
                                    Circle().stroke(Color.white.opacity(0.6), lineWidth: 2)
                                }
                            }
                            .scaleEffect(scaleForZoom(cameraDistance))
                            .opacity(opacityForZoom(cameraDistance))
                    }
                    .tag(poi.id)
                    
                }
            }
            
            // Show venue marker pins when zoomed out
            if !shouldShowPOIs {
                ForEach(vm.venues, id: \.id) { venue in
                    Marker(venue.name, systemImage: "sportscourt", coordinate: venue.center)
                        .tint(Color.indigo)
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
//        .annotationTitles(.hidden)
        .onChange(of: selectedPOIId) { _, newValue in
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
                        if let venue = vm.venues.first {
                            camera = .region(MKCoordinateRegion(center: venue.center, span: .init(latitudeDelta: 0.004, longitudeDelta: 0.004)))
                        }
                    } label: {
                        Image(systemName: "sportscourt")
                            .padding(14)
                            .glassEffect(.regular, in: .circle)
                    }
                }
            }
            .padding([.top, .horizontal],12)
        }
//        .overlay(alignment: .bottomTrailing) {
//            VStack(spacing: 10) {
//                // Reserved for extra controls
//            }
//            .padding(12)
//        }
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
    }
    
    private func scaleForZoom(_ d: CLLocationDistance) -> CGFloat {
        // 1.0 cerca, 0.6 lejos
        let minD: CLLocationDistance = 800    // muy cerca
        let maxD: CLLocationDistance = 6000   // lejos
        let t = min(1, max(0, (d - minD) / (maxD - minD)))
        return 1.0 - 0.4 * t
    }
    
    private func opacityForZoom(_ d: CLLocationDistance) -> Double {
        // 1.0 cerca, 0.4 lejos
        let minD: CLLocationDistance = 800
        let maxD: CLLocationDistance = 6000
        let t = min(1, max(0, (d - minD) / (maxD - minD)))
        return 1.0 - 0.6 * t
    }
    
    private func thinnedPOIs(from pois: [VenuePOI], distance: CLLocationDistance) -> [VenuePOI] {
        guard distance > 4500 else { return pois }
        // agrupa por “celdas” de ~50–80m
        let gridSize = 0.0008 // ~80m aprox según lat
        var seen: Set<String> = []
        return pois.compactMap { p in
            let gx = Int((p.center.latitude / gridSize).rounded(.down))
            let gy = Int((p.center.longitude / gridSize).rounded(.down))
            let key = "\(gx)-\(gy)-\(p.type.rawValue)"
            if seen.contains(key) { return nil }
            seen.insert(key)
            return p
        }
    }
}

#Preview {
    MapView(locationVm: LocationViewModel())
}

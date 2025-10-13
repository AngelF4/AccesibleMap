//
//  MapHome.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 09/10/25.
//

import SwiftUI
import MapKit

struct MapHome: View {
    @ObservedObject var vm: HomeViewModel
    @StateObject private var locationVm = LocationViewModel()
    
    @State private var selectedPOIId: UUID? = nil
    @State private var selectedPOI: VenuePOI? = nil
    
    private func findPOI(by id: UUID) -> VenuePOI? {
        guard let venue = vm.selectedVenue else { return nil }
        return venue.pois.first(where: { $0.id == id })
    }
    
    private var visiblePOIs: [VenuePOI] {
        guard let selectedVenue = vm.selectedVenue else { return [] }
        return vm.filteredPOIs(for: selectedVenue)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $vm.mapPosition, selection: $selectedPOIId) {
                UserAnnotation()
                
                if vm.showVenueList {
                    if let selectedVenue = vm.selectedVenue {
                        if vm.shouldShowPOIs {
                            ForEach(visiblePOIs, id: \.id) { poi in
                                let accessLike = isAccessLike(poi.type)
                                // Permitir que accesos/entradas vivan más lejos aunque vm.shouldShowPOIs sea false
                                let extendedVisibility = vm.cameraDistance <= 6000 && accessLike
                                // Respetar filtro de distancia general o la excepción para accesos
                                let canRender = vm.shouldShowPOIs || extendedVisibility
                                
                                let level = revealLevel(distance: vm.cameraDistance, for: poi.type)
                                let title = (level == .labeled) ? poi.type.displayName : ""
                                
                                // En MapContentBuilder solo se debe emitir contenido de mapa (Annotation/Marker/etc.).
                                // Si no se debe mostrar, simplemente no emitimos nada.
                                if canRender && level != .hidden {
                                    Annotation(title, coordinate: poi.center) {
                                        poiAnnotationBody(for: poi, level: level)
                                    }
                                    .tag(poi.id)
                                    
                                }
                            }
                        } else {
                            Marker(selectedVenue.name, systemImage: "sportscourt", coordinate: selectedVenue.center)
                                .tint(Color.indigo)
                        }
                    } else if vm.selectedCity != nil {
                        // Mostrar sedes de la ciudad elegida
                        ForEach(vm.venuesInSelectedCity) { venue in
                            Marker(venue.name, systemImage: "star.fill", coordinate: venue.center)
                                .tint(.orange)
                        }
                    }
                }
            }
            .mapControls {
                MapCompass()
                MapUserLocationButton()
            }
            .mapStyle(.standard(
                elevation: .flat,
                pointsOfInterest: vm.selectedVenue == nil ? .excludingAll : .including([.airport, .hotel])
            ))
            .mapControlVisibility(vm.selectedVenue == nil ? .hidden : .visible)
            .onMapCameraChange(frequency: .continuous) { context in
                vm.cameraInfo = context.camera
            }
            
            if vm.showVenueList, let selectedVenue = vm.selectedVenue, !selectedVenue.pois.isEmpty {
                VStack {
                    HStack {
                        Spacer()
                        if vm.isFarFromSelectedVenue {
                            Button { vm.syncCameraForStateChange(animated: true, duration: 0.4) } label: {
                                Image(systemName: "sportscourt")
                                    .padding(14)
                                    .glassEffect(.regular, in: .circle)
                            }
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: vm.isFarFromSelectedVenue)
                    HStack(spacing: 8) {
                        Spacer()
                        if vm.availableFloors(for: selectedVenue).count > 1 {
                            HStack(spacing: 4) {
                                Text("Piso")
                                Picker("Piso", selection: $vm.selectedFloor) {
                                    ForEach(vm.availableFloors(for: selectedVenue), id: \.self) { piso in
                                        Text("\(piso)").tag(piso)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(.automatic)
                            }
                            .padding(8)
                            .glassEffect(.regular)
                        }
                    }
                }
                .padding(12)
                .padding(.bottom, 16)
            }
        }
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
        .onAppear {
            locationVm.requestPermission()
            locationVm.startUpdates()
            if let venue = vm.selectedVenue ?? vm.venues.first {
                vm.selectedFloor = vm.availableFloors(for: venue).first ?? 0
            }
        }
        .onDisappear {
            locationVm.stopUpdates()
        }
        .onChange(of: vm.selectedVenue) { _, newValue in
            selectedPOIId = nil
            selectedPOI = nil
            //            vm.showOnlyEssentials = true
            if let venue = newValue {
                vm.selectedFloor = vm.availableFloors(for: venue).first ?? 0
            }
        }
    }
    
    private enum RevealLevel { case hidden, dots, icons, labeled }
    
    private func isAccessLike(_ type: pointOfInterest) -> Bool {
        switch type {
        case .access, .accessWheelchair, .parking: return true
        default: return false
        }
    }
    
    /// Umbrales diferenciados: accesos/entradas visibles desde más lejos
    private func revealLevel(distance: CLLocationDistance, for type: pointOfInterest) -> RevealLevel {
        // Otros POIs
        let farHiddenOther: CLLocationDistance = 3000
        let farDotsOther: CLLocationDistance = 1200
        let nearIconsOther: CLLocationDistance = 500
        
        // Accesos/entradas (más generosos)
        let farHiddenAccess: CLLocationDistance = 5000
        let farDotsAccess: CLLocationDistance = 4000
        let nearIconsAccess: CLLocationDistance = 200
        
        let access = isAccessLike(type)
        if access {
            if distance > farHiddenAccess { return .hidden }
            else if distance > farDotsAccess { return .dots }
            else if distance > nearIconsAccess { return .icons }
            else { return .labeled }
        } else {
            if distance > farHiddenOther { return .hidden }
            else if distance > farDotsOther { return .dots }
            else if distance > nearIconsOther { return .icons }
            else { return .labeled }
        }
    }
    
    @ViewBuilder
    private func poiAnnotationBody(for poi: VenuePOI, level: RevealLevel) -> some View {
        let isStairs = poi.type == .accessWheelchair || poi.type == .access || poi.type == .parking
        let anchor: CGFloat = isStairs ? 22 : 28
        
        switch level {
        case .hidden:
            EmptyView()
        case .dots:
            Circle()
                .frame(width: 6, height: 6)
                .opacity(0.95)
                .foregroundStyle(poi.type.color)
                .overlay(Circle().stroke(Color.white.opacity(0.85), lineWidth: 1))
        case .icons:
            Image(systemName: poi.type.icon)
                .resizable()
                .scaledToFit()
                .frame(width: anchor - 12, height: anchor - 12)
                .frame(width: anchor, height: anchor)
                .foregroundStyle(.white)
                .background(poi.type.color.gradient)
                .clipShape(isStairs ? AnyShape(RoundedRectangle(cornerRadius: 4)) : AnyShape(Circle()))
                .overlay {
                    if isStairs {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white.opacity(0.6), lineWidth: 2)
                    } else {
                        Circle().stroke(Color.white.opacity(0.6), lineWidth: 2)
                    }
                }
        case .labeled:
            Image(systemName: poi.type.icon)
                .resizable()
                .scaledToFit()
                .frame(width: anchor - 12, height: anchor - 12)
                .frame(width: anchor, height: anchor)
                .foregroundStyle(.white)
                .background(poi.type.color.gradient)
                .clipShape(isStairs ? AnyShape(RoundedRectangle(cornerRadius: 4)) : AnyShape(Circle()))
                .overlay {
                    if isStairs {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white.opacity(0.6), lineWidth: 2)
                    } else {
                        Circle().stroke(Color.white.opacity(0.6), lineWidth: 2)
                    }
                }
                .shadow(radius: 2)
                .scaleEffect(scaleForZoom(vm.cameraDistance))
        }
    }
    
    private func scaleForZoom(_ distance: CLLocationDistance) -> CGFloat {
        let minD: CLLocationDistance = 800
        let maxD: CLLocationDistance = 3000
        let t = min(1, max(0, (distance - minD) / (maxD - minD)))
        return 1.0 - 0.4 * t
    }
}

#Preview {
    @Previewable @State var previewPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: .init(latitude: 25.669122, longitude: -100.244362),
            distance: 1200,
            heading: -30,
            pitch: 64
        )
    )
    MapHome(vm: HomeViewModel())
}

#Preview {
    ContentView()
}

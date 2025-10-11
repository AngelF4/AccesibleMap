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
                            ForEach(visiblePOIs) { poi in
                                let isStairs: Bool = poi.type == .stails || poi.type == .manBathroom || poi.type == .womanBathroom
                                let anchor: CGFloat = isStairs ? 24 : 28
                                
                                Annotation(isStairs ? "" : poi.type.displayName, coordinate: poi.center) {
                                    Image(systemName: poi.type.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: anchor - 12, height: anchor - 12)
                                        .frame(width: anchor, height: anchor)
                                        .foregroundStyle(.white)
                                        .background(poi.type.color.gradient.opacity(isStairs ? 0.7 : 1))
                                        .clipShape(isStairs ? AnyShape(RoundedRectangle(cornerRadius: 4)) : AnyShape(Circle()))
                                        .overlay {
                                            if isStairs {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(Color.white.opacity(0.6), lineWidth: 2)
                                            } else {
                                                Circle().stroke(Color.white.opacity(0.6), lineWidth: 2)
                                            }
                                        }
                                        .scaleEffect(scaleForZoom(vm.cameraDistance))
                                }
                                .tag(poi.id)
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
                        HStack(spacing: 6) {
                            Text("Piso")
                            Picker("Piso", selection: $vm.selectedFloor) {
                                ForEach(vm.availableFloors(for: selectedVenue), id: \.self) { piso in
                                    Text("\(piso)").tag(piso)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 180)
                        }
                        .padding(8)
                        .glassEffect(.clear)
                        
                        Toggle(isOn: $vm.showOnlyEssentials) {
                            Text("Esenciales")
                                .font(.callout)
                        }
                        .toggleStyle(.switch)
                        .padding(8)
                        .glassEffect(.clear)
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
            vm.showOnlyEssentials = true
            if let venue = newValue {
                vm.selectedFloor = vm.availableFloors(for: venue).first ?? 0
            }
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

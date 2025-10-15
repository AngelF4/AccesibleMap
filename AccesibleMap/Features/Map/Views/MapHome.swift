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
    @ObservedObject var mapVM: MapaViewModel
    @StateObject private var locationVm = LocationViewModel()
    
    @State private var selectedPOIId: UUID? = nil
    @State private var selectedPOI: VenuePOI? = nil
    
    private func findPOI(by id: UUID) -> VenuePOI? {
        guard let venue = vm.selectedVenue else { return nil }
        return venue.pois.first(where: { $0.id == id })
    }
    
    private var renderablePOIs: [MapaViewModel.RenderablePOI] {
        guard let selectedVenue = vm.selectedVenue else { return [] }
        return mapVM.visiblePOIs(for: selectedVenue, floor: vm.selectedFloor, categories: vm.selectedCategories)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $mapVM.mapPosition, selection: $selectedPOIId) {
                if locationVm.hasLocation {
                    UserAnnotation()
                }
                
                if vm.showVenueList {
                    if let selectedVenue = vm.selectedVenue {
                        if mapVM.shouldShowPOIs {
                            ForEach(renderablePOIs) { item in
                                let poi = item.poi
                                let level = item.level
                                let title = "map.poi.title".localizedFormat(poi.type.displayName, poi.floor)
                                
                                if selectedPOIId == poi.id {
                                    Marker(title, systemImage: poi.type.icon, coordinate: poi.center)
                                        .tint(poi.type.color)
                                        .tag(poi.id)
                                } else {
                                    Annotation(title, coordinate: poi.center) {
                                        POIAnnotationView(
                                            poi: poi,
                                            level: level,
                                            isAccessLike: mapVM.isAccessLike(poi.type),
                                            scale: mapVM.scaleForZoom(mapVM.cameraDistance)
                                        )
                                        .accessibilityElement(children: .ignore)
                                        .accessibilityLabel(title)
                                        .accessibilityHint("map.poi.accessibilityHint".localized)
                                        .accessibilityAddTraits(.isButton)
                                        .accessibilityRepresentation {
                                            Button {
                                                selectedPOIId = poi.id
                                            } label: {
                                                Text(title)
                                            }
                                            .accessibilityHint("map.poi.accessibilityHint".localized)
                                        }
                                    }
                                    .tag(poi.id)
                                    .annotationTitles(mapVM.titleVisibility(for: level))
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
            .accessibilityHidden(true, isEnabled: vm.step != .hero && vm.step != .venueDetail)
            .accessibilityIgnoresInvertColors(false)
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
                mapVM.cameraInfo = context.camera
            }
            
            if vm.showVenueList, let selectedVenue = vm.selectedVenue, !selectedVenue.pois.isEmpty {
                VStack {
                    HStack {
                        Spacer()
                        if mapVM.isFarFromSelectedVenue(for: vm.selectedVenue) {
                            Button { mapVM.apply(vm.exportedState, animated: true, duration: 0.4) } label: {
                                Image(systemName: "sportscourt")
                                    .padding(14)
                                    .glassEffect(.regular, in: .circle)
                            }
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .accessibilityLabel("map.centerButton.label".localized)
                            .accessibilityHint("map.centerButton.hint".localized)
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: mapVM.isFarFromSelectedVenue(for: vm.selectedVenue))
                    HStack(spacing: 8) {
                        Spacer()
                        if vm.availableFloors(for: selectedVenue).count > 1 {
                            HStack(spacing: 4) {
                                Text("map.floorPicker.title".localized)
                                Picker("map.floorPicker.title".localized, selection: $vm.selectedFloor) {
                                    ForEach(vm.availableFloors(for: selectedVenue), id: \.self) { piso in
                                        Text("\(piso)").tag(piso)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(.automatic)
                                .accessibilityLabel("map.floorPicker.accessibilityLabel".localized)
                                .accessibilityValue("map.floorPicker.accessibilityValue".localizedFormat(vm.selectedFloor))
                                .accessibilityHint("map.floorPicker.accessibilityHint".localized)
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
        .sheet(item: $selectedPOI, onDismiss: {
            selectedPOIId = nil
            selectedPOI = nil
        }) { poi in
            SheetPOI(poi: poi, venue: vm.selectedVenue)
                .presentationBackground(.background)
                .presentationDetents([.medium])
        }
        .onAppear {
            //TODO: Mover el requestPermission a un onboarding
            locationVm.requestPermission()
            if locationVm.hasLocation {
                locationVm.startUpdates()
            }
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
            if let venue = newValue {
                vm.selectedFloor = vm.availableFloors(for: venue).first ?? 0
            }
        }
    }
}

#Preview("Home ContentView") {
    ContentView()
}

#Preview("MapHome") {
    @Previewable @State var previewPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: .init(latitude: 25.669122, longitude: -100.244362),
            distance: 1200,
            heading: -30,
            pitch: 64
        )
    )
    MapHome(vm: HomeViewModel(), mapVM: MapaViewModel())
}


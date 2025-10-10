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

    @State private var cameraInfo: MapCamera? = nil

    @State private var selectedPOIId: UUID? = nil
    @State private var selectedPOI: VenuePOI? = nil
    @State private var showOnlyEssentials: Bool = true // acceso, acceso silla, estacionamiento
    @State private var selectedFloor: Int = 0

    private func availableFloors(for venue: Venue) -> [Int] {
        let floors = Set(venue.pois.map(\.floor))
        return floors.sorted()
    }

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
        guard let venue = vm.selectedVenue else { return nil }
        return venue.pois.first(where: { $0.id == id })
    }

    private var cameraDistance: CLLocationDistance {
        cameraInfo?.distance ?? .greatestFiniteMagnitude
    }

    private var shouldShowPOIs: Bool {
        cameraDistance <= 4000
    }

    private var visiblePOIs: [VenuePOI] {
        guard let selectedVenue = vm.selectedVenue else { return [] }
        return filteredPOIs(for: selectedVenue)
    }

    var body: some View {
        Map(position: $vm.mapPosition, selection: $selectedPOIId) {
            UserAnnotation()

            if vm.showVenueList {
                if let selectedVenue = vm.selectedVenue {
                    if shouldShowPOIs {
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
                                    .scaleEffect(scaleForZoom(cameraDistance))
                            }
                            .tag(poi.id)
                        }
                    }

                    if !shouldShowPOIs {
                        Marker(selectedVenue.name, systemImage: "sportscourt", coordinate: selectedVenue.center)
                            .tint(Color.indigo)
                    }
                } else {
                    ForEach(vm.venues) { venue in
                        Marker(venue.name, systemImage: "star.fill", coordinate: venue.center)
                            .tint(.orange)
                    }
                }
            } else {
                ForEach(vm.venues) { venue in
                    Marker(venue.name, systemImage: "star.fill", coordinate: venue.center)
                        .tint(.orange)
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
            cameraInfo = context.camera
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
        .safeAreaInset(edge: .top) {
            if vm.showVenueList, let selectedVenue = vm.selectedVenue, !selectedVenue.pois.isEmpty {
                VStack {
                    HStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Text("Piso")
                            Picker("Piso", selection: $selectedFloor) {
                                ForEach(availableFloors(for: selectedVenue), id: \.self) { piso in
                                    Text("\(piso)").tag(piso)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 180)
                        }
                        .padding(8)
                        .glassEffect(.clear)

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
                            vm.focusOnSelectedVenue()
                        } label: {
                            Image(systemName: "sportscourt")
                                .padding(14)
                                .glassEffect(.regular, in: .circle)
                        }
                        .disabled(vm.selectedVenue == nil)
                    }
                }
                .padding([.top, .horizontal], 12)
            }
        }
        .onAppear {
            locationVm.requestPermission()
            locationVm.startUpdates()
            showOnlyEssentials = true
            if let venue = vm.selectedVenue ?? vm.venues.first {
                selectedFloor = availableFloors(for: venue).first ?? 0
            }
        }
        .onDisappear {
            locationVm.stopUpdates()
        }
        .onChange(of: vm.selectedVenue) { _, newValue in
            selectedPOIId = nil
            selectedPOI = nil
            showOnlyEssentials = true
            if let venue = newValue {
                selectedFloor = availableFloors(for: venue).first ?? 0
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

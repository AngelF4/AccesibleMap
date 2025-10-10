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
        Map(position: $vm.mapPosition) {
            if vm.showVenueList {
                if let selectedVenue = vm.selectedVenue {
                    UserAnnotation()
                    
                    if shouldShowPOIs {
                        ForEach(visiblePOIs) { poi in
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
                } else {
                    ForEach(vm.venues) { venue in
                        Marker(venue.name, systemImage: "star.fill",  coordinate: venue.center)
                            .tint(.orange)
                        //                    Annotation(venue.name, coordinate: venue.center) {
                        //                        Image(systemName: "mappin")
                        //                    }
                    }
                }
            }
        }
        .mapStyle(.standard(
            elevation: .realistic,
            pointsOfInterest: vm.selectedVenue == nil ? .excludingAll : .including([.airport, .hotel])))
        .mapControlVisibility(vm.selectedVenue == nil ? .hidden : .visible)
        .onMapCameraChange(frequency: .continuous) { context in
            cameraInfo = context.camera
        }
        .onChange(of: selectedPOIId) { _, newValue in
            guard let id = newValue else { return }
            selectedPOI = findPOI(by: id)
            if selectedPOI != nil { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
        }
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

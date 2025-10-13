//
//  MapView.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 07/10/25.
//

import SwiftUI
import MapKit

private struct GlassIfNeeded: ViewModifier {
    let isEnabled: Bool

    func body(content: Content) -> some View {
        if isEnabled {
            content.glassEffect(.regular)
        } else {
            content
        }
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
    @EnvironmentObject private var accessibility: AccesibilityService
    
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
                ForEach(visiblePOIs) { poi in
                    let isStairs: Bool = poi.type == .stails || poi.type == .manBathroom || poi.type == .womanBathroom
                    let baseAnchor: CGFloat = isStairs ? 24 : 28
                    let anchor = baseAnchor * CGFloat(accessibility.effectiveMarkerScale)
                    Annotation(isStairs ? "" : poi.type.displayName, coordinate: poi.center) {
                        VStack(spacing: 6) {
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
                                .scaleEffect(scaleForZoom(cameraDistance) * CGFloat(accessibility.effectiveMarkerScale))

                            if accessibility.showPOILabelsAlways || isVeryClose {
                                Text(poi.type.displayName)
                                    .font(.system(size: 11 * accessibility.effectiveFontScale, weight: .semibold))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(accessibility.mapHighContrastStyle ? Color.black.opacity(0.8) : Color.white.opacity(0.85))
                                    .foregroundStyle(accessibility.mapHighContrastStyle ? .white : .black)
                                    .clipShape(Capsule())
                                    .shadow(radius: 1)
                                    .accessibilityHidden(true)
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(poi.type.displayName), piso \(poi.floor)")
                        .accessibilityHint("Toca dos veces para abrir opciones como cómo llegar")
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
            
            MapUserLocationButton()
        }
        .onMapCameraChange(frequency: .continuous) { context in
            cameraInfo = context.camera
        }
        .mapStyle(.standard(
            elevation: .flat,
            emphasis: accessibility.mapHighContrastStyle ? .default : .muted,
            pointsOfInterest: .including([.airport, .hotel]))
        )
//        .annotationTitles(.hidden)
        .onChange(of: selectedPOIId) { _, newValue in
            guard let id = newValue else { return }
            selectedPOI = findPOI(by: id)
            if selectedPOI != nil, accessibility.hapticsEnabled { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
        }
        .onChange(of: selectedPOI) { _, newValue in
            guard let poi = newValue else { return }
            accessibility.speak("\(poi.type.displayName) en piso \(poi.floor)")
        }
        .sheet(item: $selectedPOI) { poi in
            VStack(spacing: 12) {
                Text(poi.type.displayName)
                    .font(.system(size: 20 * accessibility.effectiveFontScale, weight: .semibold, design: .rounded))
                Text("Piso: \(poi.floor)")
                    .font(.system(size: 16 * accessibility.effectiveFontScale, weight: .medium, design: .rounded))
                HStack {
                    Button("Cómo llegar") {
                        let placemark = MKPlacemark(coordinate: poi.center)
                        let item = MKMapItem(placemark: placemark)
                        item.name = poi.type.displayName
                        item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
                    }
                    .accessibilityHint("Abre la ruta hacia este punto en Apple Maps")
                    Button("Cerrar") { selectedPOI = nil }
                    .accessibilityHint("Cierra la ficha del punto de interés")
                }
            }
            .padding()
            .presentationDetents([.medium])
            .accessibilityElement(children: .contain)
        }
        .onChange(of: accessibility.showPOILabelsAlways) { newValue in
            showOnlyEssentials = !newValue
        }
        .safeAreaInset(edge: .top) {
            VStack {
                HStack(spacing: 8) {
                    // Piso
                    if accessibility.clearGlass {
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
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: .black.opacity(0.08), radius: 4, y: 1)
                    } else {
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
                        .background(Color(.systemBackground).opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: .black.opacity(0.08), radius: 4, y: 1)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Seleccionar piso")
                    .accessibilityValue("Piso \(selectedFloor)")
                    .accessibilityHint("Cambia el nivel del mapa del estadio")

                    // Filtro rápido
                    Toggle(isOn: $showOnlyEssentials) {
                        Text("Esenciales")
                            .font(.callout)
                    }
                    .toggleStyle(.switch)
                    .padding(8)
                    .background(accessibility.clearGlass ? Color.clear : Color(.systemBackground).opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .black.opacity(0.08), radius: 4, y: 1)
                    .modifier(GlassIfNeeded(isEnabled: accessibility.clearGlass))
                    .disabled(accessibility.showPOILabelsAlways)
                    .accessibilityHint(accessibility.showPOILabelsAlways ? "Las etiquetas accesibles están siempre visibles según tu configuración" : "Activa para mostrar solo accesos, rampas y estacionamientos accesibles")
                }
                HStack {
                    Spacer()
                    Button {
                        if let venue = vm.venues.first {
                            camera = .region(MKCoordinateRegion(center: venue.center, span: .init(latitudeDelta: 0.004, longitudeDelta: 0.004)))
                        }
                    } label: {
                        if accessibility.clearGlass {
                            Image(systemName: "sportscourt")
                                .padding(14)
                                .glassEffect(.regular, in: .circle)
                        } else {
                            Image(systemName: "sportscourt")
                                .padding(14)
                                .background(Color(.systemBackground).opacity(0.92))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.12), radius: 3, y: 1)
                        }
                    }
                    .accessibilityLabel("Centrar mapa")
                    .accessibilityHint("Regresa la cámara a la sede principal")
                }
            }
            .padding([.top, .horizontal],12)
        }
        .onAppear {
            vm.loadVenues()
            locationVm.startUpdates()
            selectedFloor = 1
            showOnlyEssentials = !accessibility.showPOILabelsAlways
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
        let maxD: CLLocationDistance = 3000   // lejos
        let t = min(1, max(0, (d - minD) / (maxD - minD)))
        return 1.0 - 0.4 * t
    }
    
}

#Preview {
    MapView(locationVm: LocationViewModel())
        .environmentObject(AccesibilityService.shared)
}

//
//  Home.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 09/10/25.
//

import SwiftUI
import MapKit
import SwiftUIPager

struct Home: View {
    @StateObject private var vm = HomeViewModel()
    @State private var page = Page.withIndex(0)
    @State private var pageCity = Page.withIndex(0)
    @EnvironmentObject private var accessibility: AccesibilityService

    private var animationEnabled: Bool {
        !(accessibility.reduceMotionEffective || accessibility.reduceMapAnimations)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapHome(vm: vm)
                .allowsHitTesting(vm.step != .hero)
                .environmentObject(accessibility)
            
            if !vm.showVenueList || vm.selectedVenue == nil {
                Rectangle()
                    .fill(
                        LinearGradient(colors: [Color("TextColor").opacity(0.5), .clear], startPoint: .bottom, endPoint: .center)
                    )
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
            
            VStack {
                MovingWaves(period: 6, height: 160)
                    .ignoresSafeArea(edges: .top)
                    .scaleEffect(1.1)
                    .rotationEffect(.degrees(-10))
                    .offset(y: vm.showVenueList ? -1000 : -140)
                    .accessibilityHidden(true)
                Spacer()
            }
            
            VStack(spacing: 24) {
                if vm.step != .hero {
                    // Paso 1: Elegir ciudad
                    if vm.step == .cityList {
                        VStack(spacing: 0) {
                            Pager(page: pageCity, data: vm.cities, id: \.self) { city in
                                CityCard(city: city)
                            }
                            .draggingAnimation(.custom(animation: .spring(duration: 0.1)))
                            .preferredItemSize(CGSize(width: 300 * 0.7, height: 130))
                            .itemSpacing(20)
                            .interactive(scale: 0.8)
                            .horizontal()
                            .sensitivity(.high)
                            .pagingPriority(.simultaneous)
                            .swipeInteractionArea(.allAvailable)
                            .padding(.horizontal, 20)
                            .onPageChanged { idx in
                                vm.pageCityChanged(to: idx)
                                announceSelectionIfNeeded(cityIndex: idx)
                            }
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel("Ciudades sede disponibles")
                            .accessibilityValue(vm.positionCity?.displayName ?? vm.cities.first?.displayName ?? "Sin selección")
                            .accessibilityHint("Desliza para cambiar de ciudad o pulsa dos veces para escuchar la descripción")
                            .frame(height: 130)

                            Button {
                                vm.confirmCitySelection()
                                accessibility.speak("Ciudad seleccionada: \(vm.positionCity?.displayName ?? vm.cities.first?.displayName ?? "ciudad")")
                            } label: {
                                Text("Ver sedes en \(vm.positionCity?.displayName ?? vm.cities.first?.displayName ?? "ciudad")")
                                    .fontWeight(.semibold)
                                    .font(.custom("FWC2026-NormalBlack", size: 18 * accessibility.effectiveFontScale, relativeTo: .title3))
                                    .frame(maxWidth: .infinity, minHeight: 50)
                            }
                            .buttonStyle(.glass)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                            .accessibilityHint("Confirma la selección de ciudad para ver los estadios disponibles")
                        }
                    }
                    // Paso 2: Elegir sede dentro de la ciudad
                    else if vm.step == .venueList {
                        VStack(spacing: 0) {
                            Pager(page: page, data: vm.venuesInSelectedCity, id: \.id) { item in
                                VenueCard(venue: item)
                            }
                            .draggingAnimation(.custom(animation: .spring(duration: 0.1)))
                            .preferredItemSize(CGSize(width: 270 * 0.7, height: 120))
                            .itemSpacing(20)
                            .interactive(scale: 0.9)
                            .horizontal()
                            .sensitivity(.high)
                            .pagingPriority(.simultaneous)
                            .swipeInteractionArea(.allAvailable)
                            .padding(.horizontal, 20) // peek
                            .onPageChanged { idx in
                                vm.pageVenueChanged(to: idx)
                                announceVenueIfNeeded(idx)
                            }
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel("Sedes disponibles en la ciudad")
                            .accessibilityValue(vm.position?.name ?? "Sin selección")
                            .accessibilityHint("Desliza para cambiar de estadio y escucha un resumen accesible")
                            .frame(height: 140)

                            Button {
                                if let candidate = vm.position {
                                    accessibility.speak("Entrando a \(candidate.accessibilityLabel)")
                                }
                                vm.confirmVenueSelection()
                            } label: {
                                Text("Entrar a ver ese estadio")
                                    .fontWeight(.semibold)
                                    .font(.custom("FWC2026-NormalBlack", size: 18 * accessibility.effectiveFontScale, relativeTo: .title3))
                                    .frame(maxWidth: .infinity, minHeight: 50)
                            }
                            .buttonStyle(.glass)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                            .accessibilityHint("Abre el mapa detallado de la sede elegida")
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Stadium".uppercased())
                            .font(.custom("FWC2026-UltraCondensedBold", size: 62 * accessibility.effectiveFontScale, relativeTo: .largeTitle))
                    }
                    .foregroundStyle(Color("TextColor"))
                    .shadow(color: .white.opacity(0.3), radius: 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, -20)
                    Button {
                        if animationEnabled {
                            withAnimation {
                                vm.showList()
                            }
                        } else {
                            vm.showList()
                        }
                    } label: {
                        Text("¿Listo para el partido?")
                            .fontWeight(.semibold)
                            .font(.custom("FWC2026-NormalBlack", size: 20 * accessibility.effectiveFontScale, relativeTo: .title2))
                            .frame(maxWidth: .infinity, minHeight: 50)
                    }
                    .buttonStyle(.glass)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                    .accessibilityHint("Muestra la lista de ciudades y estadios disponibles")
                }
            }
            
        }
        .onAppear {
            vm.onAppear()
        }
        .onChange(of: vm.showVenueList) {
            vm.syncCameraForStateChange(animated: animationEnabled, duration: 0.4)
        }
        .onChange(of: vm.position) {
            if vm.step != .venueDetail {
                vm.syncCameraForStateChange(animated: animationEnabled, duration: 0.4)
            }
        }
        .onChange(of: vm.selectedVenue) {
            vm.syncCameraForStateChange(animated: animationEnabled, duration: 0.4)
        }
        .onChange(of: vm.selectedCity) {
            if vm.step != .venueDetail {
                vm.syncCameraForStateChange(animated: animationEnabled, duration: 0.4)
            }
        }
        .onChange(of: vm.positionCity) {
            if vm.step != .venueDetail {
                vm.syncCameraForStateChange(animated: animationEnabled, duration: 0.4)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                if vm.showVenueList {
                    Button {
                        if animationEnabled {
                            withAnimation {
                                vm.goBack()
                            }
                        } else {
                            vm.goBack()
                        }
                    } label: {
                        Label("Regresar", systemImage: "chevron.left")
                    }
                    .accessibilityHint("Regresa al paso anterior del flujo")
                }
            }
            ToolbarItem(placement: .navigation) {
                if !vm.showVenueList {
                    NavigationLink {
                        A11ySettingsView()
                    } label: {
                        Label("Accesibilidad", systemImage: "figure")
                    }
                    .accessibilityHint("Abre los ajustes de accesibilidad personalizados")
                }
            }
        }
    }

    private func announceSelectionIfNeeded(cityIndex: Int) {
        guard vm.cities.indices.contains(cityIndex) else { return }
        let city = vm.cities[cityIndex]
        accessibility.speak("Ciudad \(city.displayName)")
    }

    private func announceVenueIfNeeded(_ index: Int) {
        guard vm.venuesInSelectedCity.indices.contains(index) else { return }
        let venue = vm.venuesInSelectedCity[index]
        accessibility.speak("Sede \(venue.accessibilityLabel)")
    }
}

#Preview {
    ContentView()
        .environmentObject(AccesibilityService.shared)
}

#Preview {
    NavigationStack {
        Home()
    }
    .environmentObject(AccesibilityService.shared)
}

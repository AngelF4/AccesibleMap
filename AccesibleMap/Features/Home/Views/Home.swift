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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapHome(vm: vm)
                .allowsHitTesting(vm.step != .hero)
            
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
                Spacer()
            }
            
            VStack(spacing: 24) {
                if vm.step != .hero {
                    // Paso 1: Elegir ciudad
                    if vm.step == .cityList {
                        VStack(spacing: 0) {
                            Pager(page: pageCity, data: vm.cities, id: \.self) { city in
                                CityCard(city: city)
                                    .scaleEffect(0.7)
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
                            }
                            
                            .frame(height: 130)
                            
                            Button {
                                vm.confirmCitySelection()
                            } label: {
                                Text("Ver sedes en \(vm.positionCity?.displayName ?? vm.cities.first?.displayName ?? "ciudad")")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                            }
                            .buttonStyle(.glass)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                        }
                    }
                    // Paso 2: Elegir sede dentro de la ciudad
                    else if vm.step == .venueList {
                        VStack(spacing: 0) {
                            Pager(page: page, data: vm.venuesInSelectedCity, id: \.id) { item in
                                VenueCard(venue: item)
                                    .scaleEffect(0.7)
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
                            }
                            .frame(height: 140)
                            
                            Button {
                                vm.confirmVenueSelection()
                            } label: {
                                Text("Entrar a ver ese estadio")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                            }
                            .buttonStyle(.glass)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Stadium".uppercased())
                            .font(.custom("FWC2026-UltraCondensedBold", size: 62, relativeTo: .largeTitle))
                    }
                    .foregroundStyle(Color("TextColor"))
                    .shadow(color: .white.opacity(0.3), radius: 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, -20)
                    Button {
                        withAnimation {
                            vm.showList()
                        }
                    } label: {
                        Text("¿Listo para el partido?")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                    }
                    .buttonStyle(.glass)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
            }
            
        }
        .onAppear {
            vm.onAppear()
        }
        .onChange(of: vm.showVenueList) {
            vm.syncCameraForStateChange(animated: true, duration: 0.4)
        }
        .onChange(of: vm.position) {
            if vm.step != .venueDetail {
                vm.syncCameraForStateChange(animated: true, duration: 0.4)
            }
        }
        .onChange(of: vm.selectedVenue) {
            vm.syncCameraForStateChange(animated: true, duration: 0.4)
        }
        .onChange(of: vm.selectedCity) {
            if vm.step != .venueDetail {
                vm.syncCameraForStateChange(animated: true, duration: 0.4)
            }
        }
        .onChange(of: vm.positionCity) {
            if vm.step != .venueDetail {
                vm.syncCameraForStateChange(animated: true, duration: 0.4)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                if vm.showVenueList {
                    Button {
                        withAnimation {
                            vm.goBack()
                        }
                    } label: {
                        Label("Regresar", systemImage: "chevron.left")
                    }
                }
            }
            ToolbarItem(placement: .navigation) {
                if !vm.showVenueList {
                    NavigationLink {
                        A11ySettingsView()
                    } label: {
                        Label("Accesibilidad", systemImage: "figure")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    NavigationStack {
        Home()
    }
}

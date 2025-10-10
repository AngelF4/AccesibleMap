//
//  Home.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 09/10/25.
//

import SwiftUI
import MapKit
import SwiftUIPager
//Text("IAngel")
//    .font(.custom("FWC2026-NormalBlack", size: 34, relativeTo: .title))

struct Home: View {
    @StateObject private var vm = HomeViewModel()
    @State private var page = Page.withIndex(0)
    @State private var cityChangeWorkItem: DispatchWorkItem?
    @State private var venueChangeWorkItem: DispatchWorkItem?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapHome(vm: vm)
                .allowsHitTesting(vm.showVenueList && vm.selectedCity != nil)
            
            if !vm.showVenueList || vm.selectedVenue == nil {
                Rectangle()
                    .fill(
                        LinearGradient(colors: [Color("LabelColor").opacity(0.5), .clear], startPoint: .bottom, endPoint: .center)
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
                if vm.showVenueList {
                    // Paso 1: Elegir ciudad
                    if vm.selectedCity == nil {
                        VStack(spacing: 0) {
                            Pager(page: page, data: vm.cities, id: \.self) { city in
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
                                // Debounce rapid page changes for cities
                                cityChangeWorkItem?.cancel()
                                let work = DispatchWorkItem { [weak vm] in
                                    guard let vm, vm.cities.indices.contains(idx) else { return }
                                    vm.positionCity = vm.cities[idx]
                                }
                                cityChangeWorkItem = work
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: work)
                            }
                            
                            .frame(height: 130)
                            
                            Button {
                                withAnimation {
                                    vm.selectedCity = vm.positionCity ?? vm.cities.first
                                }
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
                    else if vm.selectedVenue == nil {
                        VStack(spacing: 0) {
                            Pager(page: page, data: vm.venuesInSelectedCity, id: \.id) { item in
                                Text(item.name)
                                    .frame(width: 150, height: 100)
                                    .glassEffect(.regular, in: .rect(cornerRadius: 12))
                            }
                            .draggingAnimation(.custom(animation: .spring(duration: 0.1)))
                            .preferredItemSize(CGSize(width: 150, height: 100))
                            .itemSpacing(20)
                            .interactive(scale: 0.9)
                            .horizontal()
                            .sensitivity(.high)
                            .pagingPriority(.simultaneous)
                            .swipeInteractionArea(.allAvailable)
                            .padding(.horizontal, 20) // peek
                            .onPageChanged { idx in
                                // Debounce rapid page changes for venues
                                venueChangeWorkItem?.cancel()
                                let work = DispatchWorkItem { [weak vm] in
                                    guard let vm, vm.venuesInSelectedCity.indices.contains(idx) else { return }
                                    vm.position = vm.venuesInSelectedCity[idx]
                                }
                                venueChangeWorkItem = work
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: work)
                            }
                            .frame(height: 150)
                            Button {
                                withAnimation {
                                    vm.selectedVenue = vm.position
                                }
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
                    .foregroundStyle(Color("LabelColor"))
                    .shadow(color: .white.opacity(0.3), radius: 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, -20)
                    Button {
                        withAnimation(.spring(duration: 1)) {
                            vm.showVenueList = true
                            vm.positionCity = vm.cities.first
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
            vm.mapPosition = .camera(vm.cameraToShow)
            vm.positionCity = vm.cities.first
        }
        .onChange(of: vm.showVenueList) {
            withAnimation(.spring(duration: 1)) {
                vm.mapPosition = .camera(vm.cameraToShow)
            }
        }
        .onChange(of: vm.position) {
            withAnimation(.spring(duration: 2)) {
                vm.mapPosition = .camera(vm.cameraToShow)
            }
        }
        .onChange(of: vm.selectedVenue) {
            withAnimation(.spring(duration: 0.9)) {
                vm.mapPosition = .camera(vm.cameraToShow)
            }
        }
        .onChange(of: vm.selectedCity) {
            // Al pasar al paso de sedes, selecciona la primera sede de esa ciudad como "position"
            vm.position = vm.venuesInSelectedCity.first
            withAnimation(.spring(duration: 0.9)) {
                vm.mapPosition = .camera(vm.cameraToShow)
            }
        }
        .onChange(of: vm.positionCity) {
            withAnimation(.spring(duration: 0.9)) {
                vm.mapPosition = .camera(vm.cameraToShow)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                if vm.showVenueList {
                    Button {
                        withAnimation(.spring(duration: 0.8)) {
                            if vm.selectedVenue != nil {
                                vm.selectedVenue = nil
                            } else if vm.selectedCity != nil {
                                vm.selectedCity = nil
                            } else {
                                vm.showVenueList = false
                            }
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

struct MovingWaves: View {
    /// Seconds it takes for one screen-width to traverse from right to left.
    var period: TimeInterval = 8
    /// Height of the waves area.
    var height: CGFloat = 150
    
    var body: some View {
        GeometryReader { proxy in
            let width = max(proxy.size.width, 1)
            
            TimelineView(.animation) { context in
                let t = context.date.timeIntervalSinceReferenceDate
                let gap: CGFloat = -70 // negative separation (overlap)
                let step = max(1, width + gap) // distance between tile origins
                let phase = CGFloat((t.truncatingRemainder(dividingBy: period)) / period) * step
                
                // number of tiles needed to cover the screen given the step; add padding tiles
                let needed = Int(ceil(width / step)) + 3
                let count = max(3, min(8, needed))
                
                ZStack(alignment: .leading) {
                    ForEach(0..<count, id: \.self) { i in
                        Image("wavePath")
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height)
                            .offset(x: -phase + CGFloat(i) * step)
                    }
                }
            }
        }
        .frame(height: height)
        .allowsHitTesting(false)
    }
}

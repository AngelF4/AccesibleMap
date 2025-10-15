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
    @StateObject private var mapVM = MapaViewModel()
    @AccessibilityFocusState private var focusHeroCTA: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapHome(vm: vm, mapVM: mapVM)
                .allowsHitTesting(vm.step != .hero)
            
            if !vm.showVenueList || vm.selectedVenue == nil {
                Rectangle()
                    .fill(
                        LinearGradient(colors: [Color("TextColor").opacity(0.5), .clear], startPoint: .bottom, endPoint: .center)
                    )
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
            
            VStack {
                MovingWaves(
                    period: 6,
                    height: 160,
                    isAnimating: Binding(get: { !vm.showVenueList },
                                         set: { vm.showVenueList = !$0 })
                )
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
                            Pager(page: vm.pageCity, data: vm.cities, id: \.self) { city in
                                Button {
                                    vm.confirmCitySelection(city)
                                } label: {
                                    CityCard(city: city)
                                        .accessibilityValue(city.displayName)
                                }
                            }
                            .draggingAnimation(.custom(animation: .spring(duration: 0.1)))
                            .preferredItemSize(CGSize(width: 220, height: 100))
                            .itemSpacing(20)
                            .interactive(scale: 0.8)
                            .horizontal()
                            .sensitivity(.high)
                            .pagingPriority(.high)
                            .swipeInteractionArea(.allAvailable)
                            .padding(.horizontal, 20)
                            .onPageChanged { idx in
                                vm.pageCityChanged(to: idx)
                            }
                            .accessibilityLabel("home.cities.accessibilityLabel".localized)
                            .accessibilityHint("home.cities.accessibilityHint".localized)
                            .frame(height: 130)
                            
                            Button {
                                if let city = vm.positionCity ?? vm.cities.first {
                                    vm.confirmCitySelection(city)
                                } else {
                                    vm.confirmCitySelection()
                                }
                            } label: {
                                let cityName = vm.positionCity?.displayName ?? vm.cities.first?.displayName ?? "home.cityButton.placeholder".localized
                                Text("home.cityButton.title".localizedFormat(cityName))
                                    .foregroundStyle(.text)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                            }
                            .buttonStyle(.glassProminent)
                            .tint(.back)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                            .accessibilityHint("home.cityButton.hint".localized)
                        }
                    }
                    // Paso 2: Elegir sede dentro de la ciudad
                    else if vm.step == .venueList {
                        VStack(spacing: 0) {
                            Pager(page: vm.pageVenue, data: vm.venuesInSelectedCity, id: \.id) { item in
                                Button {
                                    
                                    vm.confirmVenueSelection(item)
                                } label: {
                                    VenueCard(venue: item)
                                }
                                .accessibilityValue(item.name)
                            }
                            .draggingAnimation(.custom(animation: .spring(duration: 0.1)))
                            .preferredItemSize(CGSize(width: 220, height: 100))
                            .itemSpacing(20)
                            .interactive(scale: 0.9)
                            .horizontal()
                            .sensitivity(.high)
                            .pagingPriority(.high)
                            .swipeInteractionArea(.allAvailable)
                            .padding(.horizontal, 20) // peek
                            .onPageChanged { idx in
                                vm.pageVenueChanged(to: idx)
                            }
                            .accessibilityLabel("home.venues.accessibilityLabel".localized)
                            .accessibilityHint("home.venues.accessibilityHint".localized)
                            .frame(height: 140)
                            
                            Button {
                                vm.confirmVenueSelection()
                            } label: {
                                Text("home.venueButton.label")
                                    .foregroundStyle(.text)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                            }
                            .buttonStyle(.glassProminent)
                            .tint(.back)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                            .accessibilityHint("home.venueButton.hint".localized)
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("home.hero.title")
                            .font(.custom("FWC2026-UltraCondensedBold", size: 62, relativeTo: .largeTitle))
                            .blendMode(.overlay)
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
                        Text("home.hero.cta")
                            .fontWeight(.semibold)
                            .foregroundStyle(.text)
                            .frame(maxWidth: .infinity, minHeight: 50)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.back)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                    .accessibilityLabel("home.hero.accessibilityLabel".localized)
                    .accessibilityAddTraits(.isButton)
                    .accessibilitySortPriority(100)
                    .accessibilityFocused($focusHeroCTA)
                    .accessibilityRespondsToUserInteraction(true)
                    .accessibilityHint("home.hero.accessibilityHint".localized)
                }
            }
            
        }
        .onAppear {
            vm.onAppear()
            mapVM.apply(vm.exportedState, animated: true, duration: 0.4)
            if vm.step == .hero {
                focusHeroCTA = true
            }
        }
        .onChange(of: vm.showVenueList) {
            mapVM.apply(vm.exportedState, animated: true, duration: 0.4)
        }
        .onChange(of: vm.position) {
            if vm.step != .venueDetail {
                mapVM.apply(vm.exportedState, animated: true, duration: 0.4)
            }
        }
        .onChange(of: vm.selectedVenue) {
            mapVM.apply(vm.exportedState, animated: true, duration: 0.4)
        }
        .onChange(of: vm.selectedCity) {
            if vm.step != .venueDetail {
                mapVM.apply(vm.exportedState, animated: true, duration: 0.4)
            }
        }
        .onChange(of: vm.positionCity) {
            if vm.step != .venueDetail {
                mapVM.apply(vm.exportedState, animated: true, duration: 0.4)
            }
        }
        .onChange(of: vm.step) {
            if vm.step == .hero {
                // Move VoiceOver focus to the primary CTA when entering hero
                focusHeroCTA = true
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
                        Label("home.toolbar.back", systemImage: "chevron.left")
                    }
                    .accessibilityHint("home.toolbar.backHint".localized)
                }
            }
            ToolbarItem {
                if let lastVenue = vm.lastVisitedVenue, vm.step == .hero {
                    Button {
                        if let cityIndex = vm.indexForCity(lastVenue.city) {
                            vm.pageCity = Page.withIndex(cityIndex)
                        }
                        if let venueIndex = vm.indexForVenue(lastVenue) {
                            vm.pageVenue = Page.withIndex(venueIndex)
                        }
                        withAnimation {
                            vm.openLastVisitedVenue()
                        }
                    } label: {
                        Label(lastVenue.name, systemImage: "clock.arrow.circlepath")
                            .labelStyle(.titleAndIcon)
                            .fontWeight(.semibold)
                            .foregroundStyle(.text)
                            .frame(maxWidth: .infinity, minHeight: 50)
                    }
                    .accessibilityLabel("home.toolbar.resumeLabel".localizedFormat(lastVenue.name))
                    .accessibilityHint("home.toolbar.resumeHint".localized)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 8)
                }
            }
            ToolbarItem(placement: .navigation) {
                if !vm.showVenueList {
                    //                    NavigationLink {
                    //                        A11ySettingsView()
                    //                    } label: {
                    //                        Label("Accesibilidad", systemImage: "figure")
                    //                    }
                    //                    .accessibilityHint("Abre los ajustes de accesibilidad personalizados")
                }
            }
            ToolbarItem(placement: .automatic) {
                if vm.step == .venueDetail {
                    Button {
                        vm.showCategoryFilters = true
                    } label: {
                        if vm.isUsingCategoryFilters {
                            Image(systemName: "line.3.horizontal.decrease")
                                .foregroundStyle(.back)
                                .padding(9)
                                .background(.tint, in: .circle)
                                .padding(.horizontal, -6)
                        } else {
                            Image(systemName: "line.3.horizontal.decrease")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $vm.showCategoryFilters) {
            NavigationStack {
                CategoriesFilterSheet(vm: vm)
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

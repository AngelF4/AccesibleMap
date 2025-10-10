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
    
    var body: some View {
        ZStack(alignment: .bottom) {
                MapHome(vm: vm)
                .allowsHitTesting(vm.showVenueList)
            if vm.showVenueList || vm.selectedVenue == nil {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
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
                    if vm.selectedVenue == nil {
                        Pager(page: page, data: vm.venues, id: \.id) { item in
                            Button {
                                withAnimation {
                                    vm.selectedVenue = item
                                }
                            } label: {
                                
                                Text(item.name)
                            }
                            .buttonStyle(.plain)
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
                            if vm.venues.indices.contains(idx) { vm.position = vm.venues[idx] }
                        }
                        .frame(height: 150)
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
                        }
                    } label: {
                        Text("¿Listo para el partido?")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                    }
                    .buttonStyle(.glass)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                }
            }
            
        }
        .onAppear {
            vm.updateMapPosition(animated: false)
        }
        .onChange(of: vm.showVenueList) { _ in
            vm.updateMapPosition()
        }
        .onChange(of: vm.position) { position in
            guard position != nil else { return }
            vm.focusOnVenueFromCarousel()
        }
        .onChange(of: vm.selectedVenue) { _ in
            vm.focusOnSelectedVenue()
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                if vm.showVenueList {
                    Button {
                        withAnimation(.spring(duration: 0.8)) {
                            vm.showVenueList = false
                            vm.selectedVenue = nil
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

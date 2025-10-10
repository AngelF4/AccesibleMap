//
//  Home.swift
//  AccesibleMap
//
//  Created by OpenAI Assistant on 10/10/25.
//

import SwiftUI

struct Home: View {
    @StateObject private var locationViewModel = LocationViewModel()
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectionIndex: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            HomeMap(viewModel: locationViewModel, selectedVenue: viewModel.selectedVenue)
                .ignoresSafeArea()

            if !viewModel.venues.isEmpty {
                VStack(spacing: 16) {
                    VenueSelection(venues: viewModel.venues, selectionIndex: $selectionIndex)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 12)
                        .padding(.horizontal, 8)
                }
                .padding(.bottom, 32)
            } else {
                ProgressView("Cargando venues...")
                    .padding()
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.bottom, 48)
            }
        }
        .task {
            if let selected = viewModel.selectedVenue,
               let index = viewModel.venues.firstIndex(of: selected) {
                selectionIndex = index
            }
        }
        .onChange(of: selectionIndex) { newValue in
            viewModel.selectVenue(at: newValue)
        }
        .onChange(of: viewModel.selectedVenue) { newValue in
            guard let venue = newValue,
                  let index = viewModel.venues.firstIndex(of: venue),
                  index != selectionIndex else { return }
            selectionIndex = index
        }
        .overlay(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Explora venues accesibles")
                    .font(.title2.weight(.semibold))
                if let venue = viewModel.selectedVenue {
                    Text(venue.name)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    Home()
}

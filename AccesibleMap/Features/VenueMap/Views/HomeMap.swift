//
//  HomeMap.swift
//  AccesibleMap
//
//  Created by OpenAI Assistant on 10/10/25.
//

import SwiftUI
import MapKit

struct HomeMap: View {
    @ObservedObject var viewModel: LocationViewModel
    let selectedVenue: Venue?

    @State private var camera: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $camera) {
            UserAnnotation()
            if let venue = selectedVenue {
                Marker(venue.name, coordinate: venue.coordinate)
            }
        }
        .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .including([.airport, .hotel])))
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .onAppear {
            viewModel.startUpdates()
            if let venue = selectedVenue {
                camera = cameraPosition(for: venue)
            } else {
                camera = defaultCameraPosition()
            }
        }
        .onDisappear {
            viewModel.stopUpdates()
        }
        .onChange(of: selectedVenue) { newValue in
            guard let venue = newValue else {
                camera = defaultCameraPosition()
                return
            }
            withAnimation(.easeInOut(duration: 0.45)) {
                camera = cameraPosition(for: venue)
            }
        }
        .onChange(of: viewModel.latitude) { _ in
            guard selectedVenue == nil else { return }
            camera = defaultCameraPosition()
        }
    }

    private func defaultCameraPosition() -> MapCameraPosition {
        let center = CLLocationCoordinate2D(
            latitude: viewModel.latitude ?? 25.669180,
            longitude: viewModel.longitude ?? -100.244614
        )
        return MapCameraPosition.region(
            MKCoordinateRegion(
                center: center,
                latitudinalMeters: 3_000,
                longitudinalMeters: 3_000
            )
        )
    }

    private func cameraPosition(for venue: Venue) -> MapCameraPosition {
        MapCameraPosition.region(
            MKCoordinateRegion(
                center: venue.coordinate,
                latitudinalMeters: 3_000,
                longitudinalMeters: 3_000
            )
        )
    }
}

#Preview {
    HomeMap(viewModel: LocationViewModel(), selectedVenue: .sample)
}

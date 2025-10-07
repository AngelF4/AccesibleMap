//
//  MapView.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 07/10/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: LocationViewModel
    @State private var camera: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $camera) {
            UserAnnotation()                             // punto azul del usuario
        }
        .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .including([.airport, .hotel])))
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .onAppear {
            viewModel.startUpdates()
            camera = .region(MKCoordinateRegion(
                center: .init(
                    latitude: viewModel.latitude ?? 25.669180,
                    longitude: viewModel.longitude ?? -100.244614
                ), span: .init(
                    latitudeDelta: 0.005,
                    longitudeDelta: 0.005
                ))
            )
        }
        .onDisappear {
            viewModel.stopUpdates()
        }
    }
}

#Preview {
    MapView(viewModel: LocationViewModel())
}

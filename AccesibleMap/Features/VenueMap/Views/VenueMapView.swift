//
//  VenueMapView.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import SwiftUI
import CoreLocation

struct VenueMapView: View {
    @StateObject var vm = LocationViewModel()
    @EnvironmentObject private var accessibility: AccesibilityService

    var body: some View {
        switch vm.authorizationStatus {
        case .notDetermined:
            ProgressView("Cargando datos...")
                .onAppear {
                    vm.requestPermission()
                }
        case .denied, .restricted, .authorizedAlways, .authorizedWhenInUse:
            //Mapa con ubicación predeterminada, la ubicación es opcional, solo es de referencia
            MapView(locationVm: vm)
                .environmentObject(accessibility)
        @unknown default:
            ContentUnavailableView("No pudo obtener la ubicación. Intente nuevamente.", systemImage: "mappin.slash")
        }
        if let err = vm.errorMessage {
            Text("Error: \(err)")
                .foregroundColor(.red)
        }
    }
}

#Preview {
    VenueMapView()
        .environmentObject(AccesibilityService.shared)
}

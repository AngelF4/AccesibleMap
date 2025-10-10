import SwiftUI
import MapKit

struct HomeMap: View {
    @ObservedObject var locationViewModel: LocationViewModel
    var selectedVenue: Venue?

    @State private var camera: MapCameraPosition = .automatic

    private let defaultCoordinate = CLLocationCoordinate2D(latitude: 25.669180, longitude: -100.244614)

    var body: some View {
        Map(position: $camera) {
            UserAnnotation()
            if let venue = selectedVenue {
                Marker(venue.name, coordinate: venue.coordinate)
            }
        }
        .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .including([.airport, .hotel, .park, .publicTransport])))
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .onAppear {
            locationViewModel.startUpdates()
            updateCameraPosition(for: selectedVenue)
        }
        .onChange(of: selectedVenue?.id) { _ in
            updateCameraPosition(for: selectedVenue)
        }
        .onChange(of: locationViewModel.latitude) { _ in
            guard selectedVenue == nil else { return }
            updateCameraPosition(for: nil)
        }
        .onDisappear {
            locationViewModel.stopUpdates()
        }
    }

    private func updateCameraPosition(for venue: Venue?) {
        if let venue {
            camera = .region(
                MKCoordinateRegion(
                    center: venue.coordinate,
                    latitudinalMeters: 3000,
                    longitudinalMeters: 3000
                )
            )
        } else if let latitude = locationViewModel.latitude, let longitude = locationViewModel.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            camera = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 3000,
                    longitudinalMeters: 3000
                )
            )
        } else {
            camera = .region(
                MKCoordinateRegion(
                    center: defaultCoordinate,
                    latitudinalMeters: 3000,
                    longitudinalMeters: 3000
                )
            )
        }
    }
}

#Preview {
    HomeMap(locationViewModel: LocationViewModel(), selectedVenue: Venue.samples.first)
}

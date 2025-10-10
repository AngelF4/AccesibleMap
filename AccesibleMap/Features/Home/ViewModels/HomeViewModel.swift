import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var venues: [Venue] = []
    @Published var selectedVenue: Venue?
    @Published var loadingError: String?

    init() {
        loadVenues()
    }

    func loadVenues() {
        do {
            venues = try Self.loadVenuesFromBundle()
        } catch {
            loadingError = error.localizedDescription
            venues = Venue.samples
        }

        if selectedVenue == nil {
            selectedVenue = venues.first
        } else if let current = selectedVenue, !venues.contains(current) {
            selectedVenue = venues.first
        }
    }

    func select(_ venue: Venue) {
        selectedVenue = venue
    }
}

private extension HomeViewModel {
    static func loadVenuesFromBundle() throws -> [Venue] {
        guard let url = Bundle.main.url(forResource: "venues", withExtension: "json") else {
            throw NSError(domain: "HomeViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "No se encontró el archivo venues.json en el bundle."])
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let venues = try decoder.decode([Venue].self, from: data)

        if venues.isEmpty {
            throw NSError(domain: "HomeViewModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "El archivo venues.json está vacío."])
        }

        return venues
    }
}

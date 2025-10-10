import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var locationViewModel = LocationViewModel()
    @State private var pagerSelection: UUID?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                HomeMap(locationViewModel: locationViewModel, selectedVenue: homeViewModel.selectedVenue)
                    .ignoresSafeArea()

                VStack(spacing: 12) {
                    if let error = homeViewModel.loadingError {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                    }
                    pager
                }
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Inicio")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if pagerSelection == nil {
                pagerSelection = homeViewModel.selectedVenue?.id
            }
        }
        .onChange(of: pagerSelection) { newValue in
            guard let id = newValue,
                  let venue = homeViewModel.venues.first(where: { $0.id == id }) else { return }
            if homeViewModel.selectedVenue != venue {
                homeViewModel.select(venue)
            }
        }
        .onChange(of: homeViewModel.selectedVenue?.id) { newValue in
            if pagerSelection != newValue {
                pagerSelection = newValue
            }
        }
    }

    private var pager: some View {
        Group {
            if homeViewModel.venues.isEmpty {
                ContentUnavailableView(
                    "No hay venues",
                    systemImage: "exclamationmark.triangle",
                    description: Text("Intenta actualizar más tarde.")
                )
                .frame(maxWidth: .infinity)
            } else {
                TabView(selection: $pagerSelection) {
                    ForEach(homeViewModel.venues) { venue in
                        VenuePagerCard(venue: venue)
                            .tag(venue.id)
                            .padding(.horizontal, 24)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .frame(height: 220)
            }
        }
        .frame(height: 240)
    }
}

private struct VenuePagerCard: View {
    let venue: Venue

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(venue.category.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text(venue.name)
                .font(.title3)
                .fontWeight(.bold)

            Text(venue.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(.accent)
                Text("\(venue.address), \(venue.city)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 6)
    }
}

#Preview {
    HomeView()
}

//
//  VenueSelection.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import SwiftUI

struct VenueSelection: View {
    let venues: [Venue]
    @Binding var selectionIndex: Int

    var body: some View {
        TabView(selection: $selectionIndex) {
            ForEach(Array(venues.enumerated()), id: \.offset) { index, venue in
                VenueCard(venue: venue)
                    .padding(.horizontal, 16)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: 220)
    }
}

private struct VenueCard: View {
    let venue: Venue

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(venue.name)
                .font(.title3.weight(.semibold))
            Text(venue.category)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(venue.address)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Spacer()
            HStack(spacing: 12) {
                Label("Ver en el mapa", systemImage: "mappin.circle")
                    .font(.footnote.weight(.semibold))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 8)
    }
}

#Preview {
    VenueSelection(venues: Venue.defaultVenues, selectionIndex: .constant(0))
        .padding()
        .background(Color.blue.gradient.opacity(0.3))
}

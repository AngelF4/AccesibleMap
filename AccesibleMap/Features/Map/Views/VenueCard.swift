//
//  VenueCard.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 10/10/25.
//

import SwiftUI
internal import _LocationEssentials

struct VenueCard: View {
    let venue: Venue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: "sportscourt")
                .fontWeight(.bold)
                .font(.system(size: 26))
            Text(venue.name)
                .font(.custom("FWC2026-NormalBlack", size: 16, relativeTo: .headline))
                .lineLimit(2)
                .minimumScaleFactor(0.6)
        }
        .foregroundStyle(venue.city.secondaryColor)
        .padding(.horizontal, 16)
        .frame(minHeight: 100)
        .frame(width: 200)
        .background(venue.city.primaryColor)
        .cornerRadius(30)
    }
}

#Preview {
    VenueCard(venue: Venue(name: "Estadio BBVA", city: .mty, center: .init(), pathImage: [], accessibilityDescription: "", accessibilityLabel: "", pois: []))
}

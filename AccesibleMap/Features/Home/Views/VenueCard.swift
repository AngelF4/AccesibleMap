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
                .font(.system(size: 30))
            Text(venue.name)
                .font(.custom("FWC2026-NormalBlack", size: 23, relativeTo: .title))
                .lineLimit(2)
                .minimumScaleFactor(0.6)
        }
        .foregroundStyle(venue.city.secondaryColor)
        .padding(.horizontal, 16)
        .frame(width: 270, height: 130)
        .background(venue.city.primaryColor)
        .cornerRadius(30)
    }
}

#Preview {
    VenueCard(venue: Venue(name: "Estadio BBVA", city: .mty, center: .init(), pathImage: [], accessibilityDescription: "", accessibilityLabel: "", pois: []))
}

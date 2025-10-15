//
//  CityCard.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 10/10/25.
//

import SwiftUI

struct CityCard: View {
    let city: City
    
    var body: some View {
        VStack(spacing: 30) {
//            Image("26trophy")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 150)
            Text(city.displayName.uppercased())
                .font(.custom("FWC2026-NormalBlack", size: 16, relativeTo: .title))
                .foregroundStyle(city.secondaryColor)
                .lineLimit(2)
                .minimumScaleFactor(0.6)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .frame(width: 200)
        .frame(minHeight: 100)
        .background(city.primaryColor)
        .cornerRadius(30)
    }
}

#Preview {
    CityCard(city: .mty)
    CityCard(city: .gdl)
    CityCard(city: .cdmx)
}

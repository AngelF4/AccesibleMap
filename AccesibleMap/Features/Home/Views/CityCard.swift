//
//  CityCard.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 10/10/25.
//

import SwiftUI

struct CityCard: View {
    let city: City
    @EnvironmentObject private var accessibility: AccesibilityService

    var body: some View {
        VStack(spacing: 30) {
            Text(city.displayName.uppercased())
                .font(.custom("FWC2026-NormalBlack", size: 23 * accessibility.effectiveFontScale, relativeTo: .title))
                .foregroundStyle(city.secondaryColor)
                .lineLimit(2)
                .minimumScaleFactor(0.6)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .frame(width: 300, height: 130)
        .background(city.primaryColor)
        .cornerRadius(30)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(city.displayName)
        .accessibilityHint("Ciudad sede, desliza para cambiar o selecciona para escuchar más detalles")
    }
}

#Preview {
    CityCard(city: .mty)
        .environmentObject(AccesibilityService.shared)
    CityCard(city: .gdl)
        .environmentObject(AccesibilityService.shared)
    CityCard(city: .cdmx)
        .environmentObject(AccesibilityService.shared)
}

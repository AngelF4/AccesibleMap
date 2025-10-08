//
//  MapViewModel.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 07/10/25.
//

import Foundation
import Combine

class MapViewModel: ObservableObject {
    @Published var venues: [Venue] = []
    
    private let geo = DIContainer.shared.geo
    
    func loadVenues() {
        let venue = geo.venueBBVA
        venues.append(venue)
    }
}

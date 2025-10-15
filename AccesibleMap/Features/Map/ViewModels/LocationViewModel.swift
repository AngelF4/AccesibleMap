//
//  LocationViewModel.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 07/10/25.
//

import Foundation
import CoreLocation
import Combine

class LocationViewModel: ObservableObject {
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var errorMessage: String?
    
    private var locationService = DIContainer.shared.location
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    var hasLocation: Bool {
        authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
    
    func bind() {
        locationService.$location
            .compactMap { $0 }
            .sink { [weak self] loc in
                self?.latitude = loc.coordinate.latitude
                self?.longitude = loc.coordinate.longitude
            }
            .store(in: &cancellables)
        
        locationService.$authorizationStatus
            .sink { [weak self] status in
                self?.authorizationStatus = status
            }
            .store(in: &cancellables)
        
        locationService.$error
            .compactMap { $0 }
            .sink { [weak self] err in
                self?.errorMessage = err.localizedDescription
            }
            .store(in: &cancellables)
    }
    
    func requestPermission() {
        locationService.requestPermission()
    }
    
    
    func startUpdates() {
        locationService.startUpdating()
    }
    
    func stopUpdates() {
        locationService.stopUpdating()
    }
}

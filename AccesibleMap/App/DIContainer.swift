//
//  DIContainer.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 07/10/25.
//

import Foundation

///Instacia para centralizar la creación de los servicios usados en la app, con el fin de no estar creando nuevas instancias en los viewModels
/// ```swift
/// //ejemplo de uso
/// private let di = DIContainer.shared
/// func startLocation() {
///     di.location.start()
/// }
/// ```
@MainActor
final class DIContainer {
    static var shared = DIContainer()
    
    let location = LocationService()
    let geo = GeofenceService()
    
    private init() {}
}

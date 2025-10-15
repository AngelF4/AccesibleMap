//
//  Extensions.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import Foundation
// City mapper sin tocar la definición original
extension City {
    init?(code: String) {
        switch code.lowercased() {
        case "mty": self = .mty
        case "gdl": self = .gdl
        case "cdmx": self = .cdmx
        default: return nil
        }
    }
}

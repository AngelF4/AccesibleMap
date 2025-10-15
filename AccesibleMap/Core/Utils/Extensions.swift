//
//  Extensions.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import Foundation

extension String {
    /// Returns the localized version of the string using the main bundle's Localizable table.
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    /// Returns a localized string formatted with the provided arguments.
    /// - Parameter arguments: Values to interpolate in the localized string.
    /// - Returns: A localized and formatted string.
    func localizedFormat(_ arguments: CVarArg...) -> String {
        String(format: self.localized, locale: Locale.current, arguments: arguments)
    }
}

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

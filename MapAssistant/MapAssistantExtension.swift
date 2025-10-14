//
//  MapAssistantExtension.swift
//  MapAssistant
//
//  Created by Alejandro on 14/10/25.
//

import AppIntents
import ExtensionFoundation

/// Punto de entrada de la extensión App Intents.
/// Registra los Intents disponibles en el Asistente de AccesibleMap.
@main
struct AccesibleMapAssistantExtension: AppIntentsExtension {
    var intents: [any AppIntent.Type] {
        [
            AccesibleMapAssistant.self
        ]
    }
}

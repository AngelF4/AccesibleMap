//
//  SiriExtension.swift
//  Siri
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import AppIntents
import ExtensionFoundation

@main
struct AccesibleMapAssistantExtension: AppIntentsExtension {
    var intents: [any AppIntent.Type] {
        [AccesibleMapAssistant.self]
    }
}

//
//  Siri.swift
//  Siri
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import AppIntents

struct Siri: AppIntent {
    static var title: LocalizedStringResource { "Siri" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

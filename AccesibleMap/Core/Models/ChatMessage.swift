//
//  ChatMessage.swift
//  AccesibleMap
//
//  Created by Alejandro on 07/10/25.
//

import Foundation

/// Representa un mensaje dentro del chat del asistente.
/// Se usa tanto para los mensajes del usuario como para las respuestas de la IA.
struct ChatMessage: Identifiable, Codable, Equatable {
    /// Identificador único
    let id: String
    
    /// Rol que generó el mensaje (usuario o IA)
    let role: Role
    
    /// Texto del mensaje
    var text: String
    
    /// Fecha en la que se envió / generó el mensaje
    let date: Date
    
    /// Rol del mensaje
    enum Role: String, Codable {
        case user
        case ai
    }
}

// MARK: - Mock Data (opcional para previews o testing)

extension ChatMessage {
    /// Mensajes de ejemplo para previsualizaciones o pruebas.
    static let mockData: [ChatMessage] = [
        ChatMessage(
            id: UUID().uuidString,
            role: .user,
            text: "¿Dónde están los baños más cercanos?",
            date: Date()
        ),
        ChatMessage(
            id: UUID().uuidString,
            role: .ai,
            text: "Los baños se encuentran junto a la zona de alimentos en el lado norte del estadio.",
            date: Date()
        )
    ]
}

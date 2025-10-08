//
//  AssistantViewModel.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import Foundation
import Combine

final class AssistantViewModel: ObservableObject {
    // MARK: - Public properties
    
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let ai = AIService.shared
    
    /// Envía un mensaje del usuario al servicio de IA y añade la respuesta al chat.
    func send(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(
            id: UUID().uuidString,
            role: .user,
            text: text,
            date: Date()
        )
        messages.append(userMessage)
        
        // Llama al AIService de forma asíncrona
        Task {
            await processMessage(text)
        }
    }
    
    // MARK: - Métodos privados
    private func processMessage(_ text: String) async {
        isLoading = true
        defer { isLoading = false }

        let context = buildContext()
        let fullReply = await ai.generateReply(context: context, message: text)

        // Crea el mensaje vacío para ir llenándolo
        let aiMessage = ChatMessage(
            id: UUID().uuidString,
            role: .ai,
            text: "",
            date: Date()
        )

        // Agrega el mensaje vacío a la lista
        await MainActor.run {
            messages.append(aiMessage)
        }

        // Simula envío de chunks (carácter por carácter o palabra por palabra)
        let chunks = fullReply.split(separator: " ") // puedes cambiar a .map { String($0) } si prefieres
        for (index, word) in chunks.enumerated() {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.06s entre palabras

            await MainActor.run {
                // Actualiza el texto del mensaje actual
                messages[messages.count - 1].text += (index == 0 ? "" : " ") + word
            }
        }
    }
    
    /// Construye el contexto concatenando los últimos mensajes
    private func buildContext() -> String {
        let recent = messages.suffix(6)
        return recent.map { "\($0.role.rawValue): \($0.text)" }.joined(separator: "\n")
    }
}

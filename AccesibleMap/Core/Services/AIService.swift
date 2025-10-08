//
//  AIService.swift
//  AccesibleMap
//
//  Created by Alejandro on 07/10/25.
//

import Foundation

#if canImport(FoundationModels)
import FoundationModels
#endif

/// Servicio central de Apple Intelligence.
/// Responsable de generar respuestas conversacionales y resúmenes
/// utilizando modelos de lenguaje locales (FoundationModels) en iOS 26+.
/// En dispositivos o compilaciones sin soporte, retorna valores fijos.
final class AIService {
    
    // MARK: - Singleton
    
    static let shared = AIService()
    private init() {}
    
    // MARK: - Public API
    
    /// Genera una respuesta tipo chat dado un contexto y un mensaje del usuario.
    ///
    /// - Parameters:
    ///   - context: Contexto concatenado (mensajes previos, información del venue, etc.)
    ///   - message: Texto del usuario.
    /// - Returns: Respuesta textual generada por la IA o un fallback.
    func generateReply(context: String, message: String) async -> String {
        let systemPrompt =
            """
            Eres un asistente útil que responde en español.
            Usa solo la información del contexto cuando sea relevante.
            Si la pregunta no tiene relación con el contexto, responde de forma general pero breve.
            """
        
        let prompt =
            """
            \(systemPrompt)
            
            Contexto:
            \(context)
            
            Usuario: \(message)
            Respuesta:
            """
        
        // ——— Usa Apple Intelligence si se puede ———
#if canImport(FoundationModels)
        if #available(iOS 26, *) {
            do {
                let resultText = try await simulateFoundationModel(prompt: prompt)
                return resultText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            } catch {
                print("[AIService] Error Apple Intelligence: \(error.localizedDescription)")
                return fallbackEcho(message: message)
            }
        } else {
            return fallbackEcho(message: message)
        }
#else
        return fallbackEcho(message: message)
#endif
    }
    
    
    /// Resume un texto largo en un párrafo corto.
    ///
    /// - Parameter text: Texto original.
    /// - Returns: Resumen generado o fallback simple.
    func summarize(text: String) async -> String {
        let prompt =
            """
            Resume en un párrafo conciso y claro (en español) el siguiente texto:
            
            \(text)
            """
        
#if canImport(FoundationModels)
        if #available(iOS 26, *) {
            do {
                // Borrar al conectar con AI real
                let resultText = try await simulateFoundationModel(prompt: prompt)
                return resultText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            } catch {
                print("[AIService] Error Apple Intelligence: \(error.localizedDescription)")
                return fallbackSummary(text: text)
            }
        } else {
            return fallbackSummary(text: text)
        }
#else
        return fallbackSummary(text: text)
#endif
    }
    
    
    // MARK: - Private helpers (Fallbacks)
    
    /// Placeholder de respuesta
    private func simulateFoundationModel(prompt: String) async throws -> String {
        // Simula latencia IA
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s
        // Devuelve una respuesta pseudo-inteligente
        if prompt.lowercased().contains("resume") {
            return "Resumen automático: \(prompt.prefix(60))..."
        } else {
            return "Respuesta generada localmente (sin Apple Intelligence)"
        }
    }
    
    
    /// Devuelve una respuesta tipo “eco” cuando FoundationModels no está disponible.
    private func fallbackEcho(message: String) -> String {
        return "Respuesta generada localmente (sin Apple Intelligence): \(message)"
    }
    
    /// Crea un resumen básico cortando el texto original.
    private func fallbackSummary(text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count > 140 else { return trimmed }
        let endIndex = trimmed.index(trimmed.startIndex, offsetBy: 140)
        return "\(trimmed[..<endIndex])..."
    }
}

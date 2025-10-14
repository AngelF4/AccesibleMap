//
//  Siri.swift
//  Siri
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import AppIntents

/// Intent principal para interactuar con Siri desde AccesibleMap.
/// Ejemplo de uso: “Oye Siri, ¿cómo llego al baño en AccesibleMap?”
struct AccesibleMapAssistant: AppIntent, ProvidesDialog {
    var value: Never?
    
    static var title: LocalizedStringResource = "Asistente de AccesibleMap"
    static var description = IntentDescription(
        "Responde preguntas rápidas sobre accesibilidad, como la ubicación de baños, accesos o zonas del venue."
    )
    
    // Frases de invocación más amplias
    static var suggestedInvocationPhrase: String = "¿Cómo llego al baño?"
    
    static var invocationPhrases: [LocalizedStringResource] {
        [
            // Frases naturales
            "¿Cómo llego al baño en AccesibleMap?",
            "¿Dónde están los baños de AccesibleMap?",
            "Muéstrame los baños accesibles en AccesibleMap",
            "Encuentra baños accesibles con AccesibleMap",
            "Buscar baños en AccesibleMap",
            "¿Cuál es la salida más cercana en AccesibleMap?",
            "Dime cómo salir en AccesibleMap",
            "Enséñame los accesos en AccesibleMap",
            "Abrir asistente de AccesibleMap",
            "Hablar con el asistente de AccesibleMap",
            "Preguntar en AccesibleMap sobre accesibilidad",
            "AccesibleMap, ¿dónde hay rampas?",
            "AccesibleMap, muéstrame los accesos principales",
            "Preguntar a AccesibleMap por zonas accesibles",
            "Buscar rutas accesibles en AccesibleMap",
            "Mostrar accesos para silla de ruedas en AccesibleMap",
            "¿Dónde están las rampas en AccesibleMap?",
            "¿Qué zonas son accesibles en AccesibleMap?"
        ]
    }
    
    @Parameter(title: "Pregunta")
    var pregunta: String?
    
    static var openAppWhenRun = false
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let texto: String
        let preguntaLower = (pregunta ?? "").lowercased()

        if preguntaLower.contains("baño") {
            texto = "Los baños más cercanos están junto a la zona norte, cerca de los alimentos."
        } else if preguntaLower.contains("salida") {
            texto = "La salida más cercana está detrás de la zona VIP, a tu izquierda."
        } else if preguntaLower.contains("acceso") || preguntaLower.contains("rampa") {
            texto = "Los accesos principales están señalizados en color azul en el mapa del venue."
        } else if preguntaLower.contains("zona") {
            texto = "Las zonas accesibles están distribuidas cerca de las entradas principales y cuentan con señalización táctil."
        } else {
            texto = "Puedo ayudarte a encontrar baños, accesos, salidas o zonas accesibles. Pregunta algo como: '¿Dónde están los baños?'."
        }

        return .result(dialog: IntentDialog(stringLiteral: texto))
    }
}

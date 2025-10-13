//
//  A11ySettingsView.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 08/10/25.
//

import Foundation

import SwiftUI
import AVFAudio
import Combine

enum TriBool: String, CaseIterable, Identifiable {
    case system = "Sistema", on = "Activado", off = "Desactivado"
    var id: String { rawValue }
}

struct A11ySettingsView: View {
    @EnvironmentObject private var a11y: AccesibilityService

    // Helper para mapear Bool? <-> TriBool
    private func binding(_ keyPath: ReferenceWritableKeyPath<AccesibilityService, Bool?>) -> Binding<TriBool> {
        Binding(
            get: {
                switch a11y[keyPath: keyPath] {
                case .some(true):  return .on
                case .some(false): return .off
                case .none:        return .system
                }
            },
            set: { newValue in
                switch newValue {
                case .system: a11y[keyPath: keyPath] = nil
                case .on:     a11y[keyPath: keyPath] = true
                case .off:    a11y[keyPath: keyPath] = false
                }
            }
        )
    }

    var body: some View {
        Form {
            Section("Comportamiento general") {
                Toggle("Usar ajustes del sistema cuando no haya override", isOn: $a11y.useSystemAccessibility)
                    .accessibilityHint("Cuando está activado, las preferencias del sistema se respetan si no hay personalización")
                Stepper("Tamaño extra de fuente: \(a11y.extraSize)", value: $a11y.extraSize, in: 0...3)
                    .accessibilityHint("Incrementa o reduce el tamaño del texto en la app")
                Toggle("Contraste alto en la app", isOn: $a11y.highContrast)
                    .accessibilityHint("Activa colores con mayor contraste en la interfaz")
                Toggle("Efecto cristal transparente", isOn: $a11y.clearGlass)
                    .accessibilityHint("Desactívalo si necesitas fondos sólidos sin transparencia")
                Slider(value: $a11y.preferredFontScale, in: 1.0...1.5, step: 0.05) {
                    Text("Escala de tipografía adicional")
                } minimumValueLabel: { Text("1.0") } maximumValueLabel: { Text("1.5") }
                .accessibilityValue(Text(String(format: "%.2f", a11y.preferredFontScale)))
                .accessibilityHint("Ajusta el tamaño base para textos personalizados")
            }

            Section("Overrides (Sistema / Activado / Desactivado)") {
                Picker("Reducir movimiento", selection: binding(\.reduceMotionOverride)) { ForEach(TriBool.allCases) { Text($0.rawValue).tag($0) } }
                Picker("Texto en negritas", selection: binding(\.boldTextOverride)) { ForEach(TriBool.allCases) { Text($0.rawValue).tag($0) } }
                Picker("Diferenciar sin color", selection: binding(\.differentiateWithoutColorOverride)) { ForEach(TriBool.allCases) { Text($0.rawValue).tag($0) } }
                Picker("Reducir transparencias", selection: binding(\.reduceTransparencyOverride)) { ForEach(TriBool.allCases) { Text($0.rawValue).tag($0) } }
                Picker("Formas de botón", selection: binding(\.buttonShapesOverride)) { ForEach(TriBool.allCases) { Text($0.rawValue).tag($0) } }
            }
            
            Section("Haptics y voz") {
                Toggle("Vibraciones hápticas", isOn: $a11y.hapticsEnabled)
                    .accessibilityHint("Controla si la app emite vibraciones al realizar acciones")
                Toggle("Feedback hablado", isOn: $a11y.spokenFeedbackEnabled)
                    .accessibilityHint("Activa para que la app lea mensajes contextuales en voz alta")
                Slider(value: $a11y.speechRate,
                       in: Double(AVSpeechUtteranceMinimumSpeechRate)...Double(AVSpeechUtteranceMaximumSpeechRate)) {
                    Text("Velocidad de voz")
                }
                .accessibilityValue(Text(String(format: "%.2f", a11y.speechRate)))
                .accessibilityHint("Ajusta qué tan rápido escuchas los mensajes hablados")
            }

            Section("Mapa") {
                Slider(value: $a11y.mapMarkerSize, in: 0.75...1.75, step: 0.05) {
                    Text("Tamaño de marcadores")
                }
                .accessibilityValue(Text(String(format: "%.2f", a11y.mapMarkerSize)))
                .accessibilityHint("Define qué tan grandes se muestran los puntos de interés")
                Toggle("Estilo de alto contraste", isOn: $a11y.mapHighContrastStyle)
                    .accessibilityHint("Aumenta el contraste del mapa para mejorar la visibilidad")
                Toggle("Mostrar etiquetas de POI siempre", isOn: $a11y.showPOILabelsAlways)
                    .accessibilityHint("Mantén visibles las etiquetas incluso cuando estés lejos")
                Toggle("Reducir animaciones del mapa", isOn: $a11y.reduceMapAnimations)
                    .accessibilityHint("Desactiva animaciones y movimientos de cámara dentro del mapa")
            }

            Section {
                Button("Restablecer valores de la app") {
                    a11y.highContrast = false
                    a11y.clearGlass = true
                    a11y.extraSize = 0
                    a11y.preferredFontScale = 1.0
                    a11y.hapticsEnabled = true
                    a11y.spokenFeedbackEnabled = false
                    a11y.speechRate = Double(AVSpeechUtteranceDefaultSpeechRate)
                    
                    a11y.differentiateWithoutColorOverride = nil
                    a11y.reduceTransparencyOverride = nil
                    a11y.boldTextOverride = nil
                    a11y.buttonShapesOverride = nil
                    a11y.reduceMotionOverride = nil
                    
                    a11y.mapMarkerSize = 1.0
                    a11y.mapHighContrastStyle = false
                    a11y.showPOILabelsAlways = false
                    a11y.reduceMapAnimations = false
                }
                .foregroundStyle(.red)
                .accessibilityHint("Vuelve a los valores predeterminados sugeridos")
            }
        }
        .navigationTitle("Accesibilidad")
    }
}

#Preview {
    A11ySettingsView()
        .environmentObject(AccesibilityService.shared)
}

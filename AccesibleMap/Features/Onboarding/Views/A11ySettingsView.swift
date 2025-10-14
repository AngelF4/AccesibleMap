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
    @StateObject private var a11y = AccesibilityService.shared
    
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
                a11y.objectWillChange.send()
            }
        )
    }
    
    var body: some View {
        Form {
            Section("Comportamiento general") {
                Toggle("Usar ajustes del sistema cuando no haya override", isOn: $a11y.useSystemAccessibility)
                Stepper("Tamaño extra de fuente: \(a11y.extraSize)", value: $a11y.extraSize, in: 0...3)
                Toggle("Contraste alto (app)", isOn: $a11y.highContrast)
                Toggle("Vidrio claro (clearGlass)", isOn: $a11y.clearGlass)
                Slider(value: $a11y.preferredFontScale, in: 1.0...1.5, step: 0.05) {
                    Text("Escala de tipografía adicional")
                } minimumValueLabel: { Text("1.0") } maximumValueLabel: { Text("1.5") }
            }
            
            Section("Overrides (Sistema / Activado / Desactivado)") {
                Picker("Reducir movimiento", selection: binding(\.reduceMotionOverride)) { ForEach(TriBool.allCases) { Text($0.rawValue).tag($0) } }
                Picker("Texto en negritas", selection: binding(\.boldTextOverride)) { ForEach(TriBool.allCases) { Text($0.rawValue).tag($0) } }
                Picker("Diferenciar sin color", selection: binding(\.differentiateWithoutColorOverride)) { ForEach(TriBool.allCases) { Text($0.rawValue).tag($0) } }
                Picker("Reducir transparencias", selection: binding(\.reduceTransparencyOverride)) { ForEach(TriBool.allCases) { Text($0.rawValue).tag($0) } }
                Picker("Formas de botón", selection: binding(\.buttonShapesOverride)) { ForEach(TriBool.allCases) { Text($0.rawValue).tag($0) } }
            }
            
            Section("Haptics y voz") {
                Toggle("Haptics", isOn: $a11y.hapticsEnabled)
                Toggle("Feedback hablado", isOn: $a11y.spokenFeedbackEnabled)
                Slider(value: $a11y.speechRate,
                       in: Double(AVSpeechUtteranceMinimumSpeechRate)...Double(AVSpeechUtteranceMaximumSpeechRate)) {
                    Text("Velocidad de voz")
                }
            }
            
            Section("Mapa") {
                Slider(value: $a11y.mapMarkerSize, in: 0.75...1.75, step: 0.05) {
                    Text("Tamaño de marcadores")
                }
                Toggle("Estilo de alto contraste", isOn: $a11y.mapHighContrastStyle)
                Toggle("Mostrar etiquetas de POI siempre", isOn: $a11y.showPOILabelsAlways)
                Toggle("Reducir animaciones del mapa", isOn: $a11y.reduceMapAnimations)
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
            }
        }
        .navigationTitle("Accesibilidad")
    }
}

#Preview {
    A11ySettingsView()
}

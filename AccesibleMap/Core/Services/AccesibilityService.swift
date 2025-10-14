//
//  AccesibilityService.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 08/10/25.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import AVFAudio // para TTS opcional

final class AccesibilityService: ObservableObject {
    static let shared = AccesibilityService()
    private var cancellables = Set<AnyCancellable>()
    
    // Preferencias de la App (overrides)
    @AppStorage("useSystemAccessibility") var useSystemAccessibility = true
    
    @AppStorage("clearGlass") var clearGlass: Bool = true
    @AppStorage("extraSize") var extraSize: Int = 0
    
    @AppStorage("highContrast") var highContrast: Bool = false
    @AppStorage("differentiateWithoutColorOverride") var differentiateWithoutColorOverride: Bool?
    @AppStorage("reduceTransparencyOverride") var reduceTransparencyOverride: Bool?
    @AppStorage("boldTextOverride") var boldTextOverride: Bool?
    @AppStorage("buttonShapesOverride") var buttonShapesOverride: Bool?
    @AppStorage("reduceMotionOverride") var reduceMotionOverride: Bool?
    
    @AppStorage("preferredFontScale") var preferredFontScale: Double = 1.0 // 1.0 = sin extra
    
    @AppStorage("hapticsEnabled") var hapticsEnabled: Bool = true
    @AppStorage("spokenFeedbackEnabled") var spokenFeedbackEnabled: Bool = false
    @AppStorage("speechRate") var speechRate: Double = Double(AVSpeechUtteranceDefaultSpeechRate)
    
    // Preferencias específicas para tu mapa
    @AppStorage("mapMarkerSize") var mapMarkerSize: Double = 1.0
    @AppStorage("mapHighContrastStyle") var mapHighContrastStyle: Bool = false
    @AppStorage("showPOILabelsAlways") var showPOILabelsAlways: Bool = false
    @AppStorage("reduceMapAnimations") var reduceMapAnimations: Bool = false
    
    // Lecturas del sistema (UIKit/SwiftUI env proxies)
    var systemReduceMotion: Bool { UIAccessibility.isReduceMotionEnabled }
    var systemBoldText: Bool { UIAccessibility.isBoldTextEnabled }
    var systemDifferentiateWithoutColor: Bool { UIAccessibility.shouldDifferentiateWithoutColor }
    var systemReduceTransparency: Bool { UIAccessibility.isReduceTransparencyEnabled }
    var systemButtonShapes: Bool { UIAccessibility.buttonShapesEnabled }
    
    // Valores “efectivos” (override ?? sistema)
    var reduceMotionEffective: Bool { reduceMotionOverride ?? systemReduceMotion }
    var boldTextEffective: Bool { boldTextOverride ?? systemBoldText }
    var differentiateWithoutColorEffective: Bool { differentiateWithoutColorOverride ?? systemDifferentiateWithoutColor }
    var reduceTransparencyEffective: Bool { reduceTransparencyOverride ?? systemReduceTransparency }
    var buttonShapesEffective: Bool { buttonShapesOverride ?? systemButtonShapes }
    
    // Observa cambios del sistema para actualizar vistas
    init() {
        NotificationCenter.default.publisher(for: UIAccessibility.reduceMotionStatusDidChangeNotification)
            .merge(with:
                    NotificationCenter.default.publisher(for: UIAccessibility.boldTextStatusDidChangeNotification),
                   NotificationCenter.default.publisher(for: UIAccessibility.differentiateWithoutColorDidChangeNotification),
                   NotificationCenter.default.publisher(for: UIAccessibility.reduceTransparencyStatusDidChangeNotification),
                   NotificationCenter.default.publisher(for: UIAccessibility.buttonShapesEnabledStatusDidChangeNotification)
            )
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    // Utilidad TTS opcional
    func speak(_ text: String) {
        guard spokenFeedbackEnabled else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = Float(speechRate)
        AVSpeechSynthesizer().speak(utterance)
    }
}

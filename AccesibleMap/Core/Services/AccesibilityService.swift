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

    // MARK: - Persistencia de preferencias
    @AppStorage("useSystemAccessibility") private var useSystemAccessibilityStorage = true
    @AppStorage("clearGlass") private var clearGlassStorage: Bool = true
    @AppStorage("extraSize") private var extraSizeStorage: Int = 0
    @AppStorage("highContrast") private var highContrastStorage: Bool = false
    @AppStorage("differentiateWithoutColorOverride") private var differentiateWithoutColorOverrideStorage: Bool?
    @AppStorage("reduceTransparencyOverride") private var reduceTransparencyOverrideStorage: Bool?
    @AppStorage("boldTextOverride") private var boldTextOverrideStorage: Bool?
    @AppStorage("buttonShapesOverride") private var buttonShapesOverrideStorage: Bool?
    @AppStorage("reduceMotionOverride") private var reduceMotionOverrideStorage: Bool?
    @AppStorage("preferredFontScale") private var preferredFontScaleStorage: Double = 1.0
    @AppStorage("hapticsEnabled") private var hapticsEnabledStorage: Bool = true
    @AppStorage("spokenFeedbackEnabled") private var spokenFeedbackEnabledStorage: Bool = false
    @AppStorage("speechRate") private var speechRateStorage: Double = Double(AVSpeechUtteranceDefaultSpeechRate)
    @AppStorage("mapMarkerSize") private var mapMarkerSizeStorage: Double = 1.0
    @AppStorage("mapHighContrastStyle") private var mapHighContrastStyleStorage: Bool = false
    @AppStorage("showPOILabelsAlways") private var showPOILabelsAlwaysStorage: Bool = false
    @AppStorage("reduceMapAnimations") private var reduceMapAnimationsStorage: Bool = false

    // MARK: - API pública
    var useSystemAccessibility: Bool {
        get { useSystemAccessibilityStorage }
        set { update(&useSystemAccessibilityStorage, with: newValue) }
    }

    var clearGlass: Bool {
        get { clearGlassStorage }
        set { update(&clearGlassStorage, with: newValue) }
    }

    var extraSize: Int {
        get { extraSizeStorage }
        set { update(&extraSizeStorage, with: newValue) }
    }

    var highContrast: Bool {
        get { highContrastStorage }
        set { update(&highContrastStorage, with: newValue) }
    }

    var differentiateWithoutColorOverride: Bool? {
        get { differentiateWithoutColorOverrideStorage }
        set { update(&differentiateWithoutColorOverrideStorage, with: newValue) }
    }

    var reduceTransparencyOverride: Bool? {
        get { reduceTransparencyOverrideStorage }
        set { update(&reduceTransparencyOverrideStorage, with: newValue) }
    }

    var boldTextOverride: Bool? {
        get { boldTextOverrideStorage }
        set { update(&boldTextOverrideStorage, with: newValue) }
    }

    var buttonShapesOverride: Bool? {
        get { buttonShapesOverrideStorage }
        set { update(&buttonShapesOverrideStorage, with: newValue) }
    }

    var reduceMotionOverride: Bool? {
        get { reduceMotionOverrideStorage }
        set { update(&reduceMotionOverrideStorage, with: newValue) }
    }

    var preferredFontScale: Double {
        get { preferredFontScaleStorage }
        set { update(&preferredFontScaleStorage, with: newValue) }
    }

    var hapticsEnabled: Bool {
        get { hapticsEnabledStorage }
        set { update(&hapticsEnabledStorage, with: newValue) }
    }

    var spokenFeedbackEnabled: Bool {
        get { spokenFeedbackEnabledStorage }
        set { update(&spokenFeedbackEnabledStorage, with: newValue) }
    }

    var speechRate: Double {
        get { speechRateStorage }
        set { update(&speechRateStorage, with: newValue) }
    }

    var mapMarkerSize: Double {
        get { mapMarkerSizeStorage }
        set { update(&mapMarkerSizeStorage, with: newValue) }
    }

    var mapHighContrastStyle: Bool {
        get { mapHighContrastStyleStorage }
        set { update(&mapHighContrastStyleStorage, with: newValue) }
    }

    var showPOILabelsAlways: Bool {
        get { showPOILabelsAlwaysStorage }
        set { update(&showPOILabelsAlwaysStorage, with: newValue) }
    }

    var reduceMapAnimations: Bool {
        get { reduceMapAnimationsStorage }
        set { update(&reduceMapAnimationsStorage, with: newValue) }
    }

    // Lecturas del sistema (UIKit/SwiftUI env proxies)
    var systemReduceMotion: Bool { UIAccessibility.isReduceMotionEnabled }
    var systemBoldText: Bool { UIAccessibility.isBoldTextEnabled }
    var systemDifferentiateWithoutColor: Bool { UIAccessibility.shouldDifferentiateWithoutColor }
    var systemReduceTransparency: Bool { UIAccessibility.isReduceTransparencyEnabled }
    var systemButtonShapes: Bool { UIAccessibility.buttonShapesEnabled }

    // Valores “efectivos” (override ?? sistema)
    var reduceMotionEffective: Bool {
        if useSystemAccessibility { return reduceMotionOverride ?? systemReduceMotion }
        return reduceMotionOverride ?? false
    }

    var boldTextEffective: Bool {
        if useSystemAccessibility { return boldTextOverride ?? systemBoldText }
        return boldTextOverride ?? false
    }

    var differentiateWithoutColorEffective: Bool {
        if useSystemAccessibility { return differentiateWithoutColorOverride ?? systemDifferentiateWithoutColor }
        return differentiateWithoutColorOverride ?? false
    }

    var reduceTransparencyEffective: Bool {
        if useSystemAccessibility { return reduceTransparencyOverride ?? systemReduceTransparency }
        return reduceTransparencyOverride ?? false
    }

    var buttonShapesEffective: Bool {
        if useSystemAccessibility { return buttonShapesOverride ?? systemButtonShapes }
        return buttonShapesOverride ?? false
    }

    /// Factor global para escalar tipografías manuales.
    var effectiveFontScale: Double {
        let base = useSystemAccessibility ? 1.0 : preferredFontScale
        return base + (Double(extraSize) * 0.1)
    }

    /// Escala aplicada a los marcadores del mapa.
    var effectiveMarkerScale: Double {
        max(0.5, min(2.0, mapMarkerSize))
    }

    // MARK: - Ciclo de vida
    init() {
        NotificationCenter.default.publisher(for: UIAccessibility.reduceMotionStatusDidChangeNotification)
            .merge(with:
                NotificationCenter.default.publisher(for: UIAccessibility.boldTextStatusDidChangeNotification),
                NotificationCenter.default.publisher(for: UIAccessibility.differentiateWithoutColorDidChangeNotification),
                NotificationCenter.default.publisher(for: UIAccessibility.reduceTransparencyStatusDidChangeNotification),
                NotificationCenter.default.publisher(for: UIAccessibility.buttonShapesEnabledStatusDidChangeNotification)
            )
            .sink { [weak self] _ in self?.notifyChange() }
            .store(in: &cancellables)
    }

    // Utilidad TTS opcional
    func speak(_ text: String) {
        guard spokenFeedbackEnabled else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = Float(speechRate)
        AVSpeechSynthesizer().speak(utterance)
    }

    // MARK: - Helpers
    private func notifyChange() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    private func update<Value: Equatable>(_ storage: inout Value, with newValue: Value) {
        guard storage != newValue else { return }
        storage = newValue
        notifyChange()
    }

    private func update<Value>(_ storage: inout Value?, with newValue: Value?) where Value: Equatable {
        if storage == nil && newValue == nil { return }
        if let storageValue = storage, let newValue {
            guard storageValue != newValue else { return }
            storage = newValue
            notifyChange()
            return
        }
        storage = newValue
        notifyChange()
    }
}

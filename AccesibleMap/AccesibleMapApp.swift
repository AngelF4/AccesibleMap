//
//  AccesibleMapApp.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import SwiftUI

@main
struct AccesibleMapApp: App {
    @StateObject private var accessibilityService = AccesibilityService.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(accessibilityService)
                .environment(\.accessibilityDifferentiateWithoutColor, accessibilityService.differentiateWithoutColorEffective)
                .environment(\.accessibilityReduceMotion, accessibilityService.reduceMotionEffective)
                .environment(\.accessibilityReduceTransparency, accessibilityService.reduceTransparencyEffective)
                .environment(\.accessibilityBoldText, accessibilityService.boldTextEffective)
                .environment(\.accessibilityShowButtonShapes, accessibilityService.buttonShapesEffective)
                .environment(\.colorSchemeContrast, accessibilityService.highContrast ? .increased : .standard)
        }
    }

//    init() {
//        setupApparience()
//    }
}

//extension AccesibleMapApp {
//    func setupApparience() {
//        // Tint global
//        if let accent = UIColor(named: "AccentColor") {
//            UIView.appearance().tintColor = accent
//            UIWindow.appearance().tintColor = accent
//        }
//        
//        let standardAppearance = UINavigationBarAppearance()
//        
//        standardAppearance.titleTextAttributes = [ //Titulo compacto
//            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
//            
//        ]
//        standardAppearance.largeTitleTextAttributes = [ //titulo largo
//            .font: UIFont.systemFont(ofSize: 34, weight: .heavy),
//        ]
//        
//        let compactAppearance = standardAppearance.copy()
//        UINavigationBar.appearance().standardAppearance = standardAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = standardAppearance
//        UINavigationBar.appearance().compactAppearance = compactAppearance
//        
//        return
//    }
//}

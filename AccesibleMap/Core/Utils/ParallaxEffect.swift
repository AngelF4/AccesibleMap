//
//  ParallaxEffect.swift
//  AccesibleMap
//
//  Created by Alejandro on 15/10/25.
//

import Foundation
import SwiftUI

struct ParallaxEffect: ViewModifier {
    var pitch: Double
    var roll: Double

    func body(content: Content) -> some View {
        // Limitar y suavizar los valores de pitch y roll
        let maxAngle: Double = 5 // máximo grados de rotación visual
        let limitedPitch = max(-0.3, min(0.3, pitch)) // recorta entre -0.3 y +0.3 rad
        let limitedRoll = max(-0.3, min(0.3, roll))
        
        return content
            .rotation3DEffect(
                .degrees(limitedRoll * (maxAngle / 0.3)), // movimiento lateral
                axis: (x: 0, y: 1, z: 0)
            )
            .rotation3DEffect(
                .degrees(limitedPitch * (maxAngle / 0.6)), // movimiento vertical
                axis: (x: 1, y: 0, z: 0)
            )
            .animation(.easeOut(duration: 0.2), value: pitch)
            .animation(.easeOut(duration: 0.2), value: roll)
    }
}

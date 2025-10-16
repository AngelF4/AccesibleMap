//
//  ParallaxRay.swift
//  AccesibleMap
//
//  Created by Alejandro on 15/10/25.
//

import SwiftUI

/// Franja de luz (“rayo”) que se mueve según el ángulo del dispositivo
struct ParallaxRay: View {
    var pitch: Double   // adelante/atrás
    var roll: Double    // izquierda/derecha
    
    // Ajustes de sensibilidad
    private let maxOffsetFactor: CGFloat = 0.15
    private let maxRotation: Double = 10
    private let clamp: Double = 0.35             
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let baseAngle: Double = -25
            let limitedRoll = max(-clamp, min(clamp, roll))
            let limitedPitch = max(-clamp, min(clamp, pitch))
            
            let maxOffsetX = w * maxOffsetFactor
            let maxOffsetY = h * maxOffsetFactor
            
            let offsetX = CGFloat(limitedRoll / clamp) * maxOffsetX
            let offsetY = CGFloat(-limitedPitch / clamp) * maxOffsetY
            
            let rayThickness = max(20, min(30, min(w, h) * 0.05))
            let rayLength = max(w, h) * 1.2
            
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.0),
                                .white.opacity(0.4),
                                .white.opacity(0.0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: rayLength, height: rayThickness)
                    .blur(radius: rayThickness * 0.6)
                    .offset(x: offsetX, y: offsetY)
                    .rotationEffect(.degrees(baseAngle + (limitedRoll / clamp) * maxRotation))
                    .blendMode(.screen)
                    .opacity(0.6)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.0),
                                .white.opacity(0.15),
                                .white.opacity(0.0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: rayLength, height: rayThickness * 2.2)
                    .blur(radius: rayThickness * 1.2)
                    .offset(x: offsetX, y: offsetY)
                    .rotationEffect(.degrees(baseAngle + (limitedRoll / clamp) * maxRotation))
                    .blendMode(.screen)
                    .opacity(0.6)
            }
            .frame(width: w, height: h)
        }
        .allowsHitTesting(false)
    }
}

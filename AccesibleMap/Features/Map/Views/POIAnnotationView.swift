//
//  POIAnnotationView.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 15/10/25.
//

import SwiftUI

struct POIAnnotationView: View {
    let poi: VenuePOI
    let level: MapaViewModel.RevealLevel
    let isAccessLike: Bool
    let scale: CGFloat
    
    private var anchor: CGFloat { isAccessLike ? 22 : 28 }
    
    var body: some View {
        switch level {
        case .hidden:
            EmptyView()
            
        case .dots:
            Circle()
                .frame(width: 6, height: 6)
                .opacity(0.95)
                .foregroundStyle(poi.type.color)
                .overlay(Circle().stroke(Color.white.opacity(0.85), lineWidth: 1))
            
        case .icons, .labeled:
            Image(systemName: poi.type.icon)
                .resizable()
                .scaledToFit()
                .frame(width: anchor - 12, height: anchor - 12)
                .frame(width: anchor, height: anchor)
                .foregroundStyle(.white)
                .background(poi.type.color.gradient)
                .clipShape(isAccessLike ? AnyShape(RoundedRectangle(cornerRadius: 4)) : AnyShape(Circle()))
                .overlay {
                    if isAccessLike {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white.opacity(0.6), lineWidth: 2)
                    } else {
                        Circle().stroke(Color.white.opacity(0.6), lineWidth: 2)
                    }
                }
                .shadow(radius: level == .labeled ? 2 : 0)
                .scaleEffect(level == .labeled ? scale : 1)
        }
    }
}

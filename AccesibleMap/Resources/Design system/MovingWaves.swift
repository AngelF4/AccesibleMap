//
//  MovingWaves.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 11/10/25.
//

import SwiftUI

struct MovingWaves: View {
    /// Seconds it takes for one screen-width to traverse from right to left.
    var period: TimeInterval = 8
    /// Height of the waves area.
    var height: CGFloat = 150
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        if reduceMotion {
            Image("wavePath")
                .resizable()
                .scaledToFill()
                .frame(height: height)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            GeometryReader { proxy in
                let width = max(proxy.size.width, 1)
                
                TimelineView(.animation) { context in
                    let t = context.date.timeIntervalSinceReferenceDate
                    let gap: CGFloat = -70 // negative separation (overlap)
                    let step = max(1, width + gap) // distance between tile origins
                    let phase = CGFloat((t.truncatingRemainder(dividingBy: period)) / period) * step
                    
                    // number of tiles needed to cover the screen given the step; add padding tiles
                    let needed = Int(ceil(width / step)) + 3
                    let count = max(3, min(8, needed))
                    
                    ZStack(alignment: .leading) {
                        ForEach(0..<count, id: \.self) { i in
                            Image("wavePath")
                                .resizable()
                                .scaledToFill()
                                .frame(width: width, height: height)
                                .offset(x: -phase + CGFloat(i) * step)
                        }
                    }
                }
            }
            .frame(height: height)
            .allowsHitTesting(false)
        }
    }
}

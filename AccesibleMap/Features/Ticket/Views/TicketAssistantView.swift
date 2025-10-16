//
//  TicketAssistantView.swift
//  AccesibleMap
//
//  Created by Alejandro on 15/10/25.
//

import SwiftUI

struct TicketAssistantView: View {
    @State private var showCamera = false
    @State private var ticketCaptured = false
    @State private var flipped = false
    @StateObject private var motion = MotionManager()
    @State private var image: UIImage? = nil
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        VStack {
            ZStack {
                TicketPlaceholder()
                    .opacity(flipped ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(flipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .apply(!reduceMotion) { view in
                        view.modifier(ParallaxEffect(pitch: motion.pitch, roll: motion.roll))
                    }
                    .accessibilityHidden(flipped)
                    .accessibilityLabel(Text("ticket.placeholder.label".localized))
                    .accessibilityHint(Text("ticket.placeholder.hint".localized))
                
                TicketView()
                    .opacity(flipped ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(flipped ? 0 : -180),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .apply(!reduceMotion) { view in
                        view.modifier(ParallaxEffect(pitch: motion.pitch, roll: motion.roll))
                    }
                    .accessibilityHidden(!flipped)
            }
            .animation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.8), value: flipped)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button {
                flipped.toggle()
//                showCamera.toggle()
            } label: {
                Text("ticket.button.photo".localized)
                    .font(.headline)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 50)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel(Text("ticket.button.photo.label".localized))
            .accessibilityHint(Text("ticket.button.photo.hint".localized))
            .sheet(isPresented: $showCamera) {
                CameraViewModel(image: $image, onImageTaken: {
                    ticketCaptured.toggle()
                    flipped.toggle()
                })
            }
        }
        .padding(15)
    }
}

extension View {
    @ViewBuilder
    func apply<Content: View>(
        _ condition: Bool,
        _ transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    TicketAssistantView()
}

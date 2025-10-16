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
    
    var body: some View {
        VStack {
            ZStack {
                TicketPlaceholder()
                    .opacity(flipped ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(flipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .modifier(ParallaxEffect(pitch: motion.pitch, roll: motion.roll))
                
                TicketView()
                    .opacity(flipped ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(flipped ? 0 : -180),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .modifier(ParallaxEffect(pitch: motion.pitch, roll: motion.roll))
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: flipped)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button {
                showCamera.toggle()
            } label: {
                Text("ticket.button.photo".localized)
                    .font(.headline)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 50)
            }
            .buttonStyle(.borderedProminent)
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

#Preview {
    TicketAssistantView()
}

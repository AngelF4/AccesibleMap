//
//  MotionManager.swift
//  AccesibleMap
//
//  Created by Alejandro on 15/10/25.
//

import Foundation
import CoreMotion
import SwiftUI
import Combine
import simd

final class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    private var queue = OperationQueue()
    
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    
    init() {
        motionManager.deviceMotionUpdateInterval = 1/60 // 60Hz
        startUpdates()
    }
    
    func startUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: queue) { [weak self] motion, _ in
                guard let motion = motion else { return }
                DispatchQueue.main.async {
                    self?.pitch = motion.attitude.pitch
                    self?.roll = motion.attitude.roll
                }
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}


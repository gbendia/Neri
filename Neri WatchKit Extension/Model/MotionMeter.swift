import Foundation
import CoreMotion

class MotionMeter {
    
    static let singleton = MotionMeter()
    
    private let motionManager = CMMotionManager()
    
    private init() {
        motionManager.deviceMotionUpdateInterval = 1.0 / 50
    }
    
}

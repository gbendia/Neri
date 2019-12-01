import Foundation
import WatchKit
import HealthKit
import CoreMotion
import WatchConnectivity

class BaseInterfaceController: WKInterfaceController, MotionMeterDelegate {

    override func willActivate() {
        super.willActivate()
        DispatchQueue(label: "HeartRateQueue").async {
            HeartRateMeter.singleton.startFetching()
        }
        DispatchQueue(label: "MotionQueue").async {
            MotionMeter.singleton.setDelegate(self)
            MotionMeter.singleton.startFetching()
        }
        ConnectivitySession.singleton.startConnection()
    }
    
    func fallDetected() {
        DispatchQueue.main.async { [weak self] in
            self?.presentController(withName: "countdownInterfaceController", context: self)
        }
    }
        
}

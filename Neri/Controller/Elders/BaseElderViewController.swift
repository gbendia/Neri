import Foundation
import UIKit

class BaseElderViewController: UIViewController, NeriWatchConnectivityDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WatchConncetivityReceiver.singleton.setDelegate(self)
    }
    
    func didReceiveHeartRate(_ heartRate: Int) {
        if (heartRate != Elder.singleton.heartRate) {
            Elder.singleton.heartRate = heartRate
        }
    }
    
    func didReceiveFallDetected(_ fallDetected: Bool) {
        if (fallDetected != Elder.singleton.fallDetected) {
            Elder.singleton.fallDetected = fallDetected
        }
    }
    
}

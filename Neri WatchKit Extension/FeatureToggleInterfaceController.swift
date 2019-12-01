import Foundation
import WatchKit

class FeatureToggleInterfaceController: WKInterfaceController {
    
    
    @IBAction func toggleHeartRatePressed() {
        HeartRateMeter.singleton.toggle()
    }
    
    @IBAction func toggleMotionDataPressed() {
    }
    
}

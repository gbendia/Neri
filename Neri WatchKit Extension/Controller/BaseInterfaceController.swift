import Foundation
import WatchKit
import HealthKit
import CoreMotion
import WatchConnectivity

class BaseInterfaceController: WKInterfaceController {
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        HeartRateMeter.singleton.startFetching()
        ConnectivitySession.singleton.startConnection()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
        
}

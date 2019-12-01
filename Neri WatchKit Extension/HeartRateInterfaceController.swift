import WatchKit
import Foundation

class HeartRateInterfaceController: BaseInterfaceController, HeartRateDelegate {

    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        HeartRateMeter.singleton.setHeartRateDelegate(self)
    }
    
    override func willActivate() {
        super.willActivate()
        
        heartRateLabel.setText("--")
    }
    
    func heartRateUpdated(heartRate: Int) {
        heartRateLabel.setText("\(heartRate)")
        // Send to iPhone
    }

}

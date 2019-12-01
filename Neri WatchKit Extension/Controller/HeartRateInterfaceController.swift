import WatchKit
import Foundation

class HeartRateInterfaceController: BaseInterfaceController, HeartRateDelegate {

    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        HeartRateMeter.singleton.setHeartRateDelegate(self)
        
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    func heartRateUpdated(heartRate: Int) {
        if (HeartRateMeter.singleton.isActive()) {
            ConnectivitySession.singleton.sendData("heartRate", heartRate)
            heartRateLabel.setText("\(heartRate)")
        } else {
            heartRateLabel.setText("--")
        }
    }

}

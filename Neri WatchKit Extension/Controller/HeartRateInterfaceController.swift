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
    }
    
    func heartRateUpdated(heartRate: Int) {
        print("Heart rate updated")
        if (HeartRateMeter.singleton.isActive()) {
            print("Sending heart rate")
            ConnectivitySession.singleton.sendData("heartRate", heartRate)
            heartRateLabel.setText("\(heartRate)")
        } else {
            heartRateLabel.setText("--")
        }
    }

}

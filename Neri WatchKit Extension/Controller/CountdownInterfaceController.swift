import WatchKit
import Foundation

class CountdownInterfaceController: WKInterfaceController {
    
    private var cowntdownTimer: Timer?
    
    private var currentTimeLeft = 15
    
    @IBOutlet weak var countDownLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        cowntdownTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(cowntdown), userInfo: nil, repeats: true)
        
        cowntdownTimer?.fire()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    @objc private func cowntdown() {
        if (currentTimeLeft >= 0) {
            DispatchQueue.main.async {
                self.countDownLabel.setText("\(self.currentTimeLeft)")
                self.currentTimeLeft -= 1
            }
        }
        
    }

    @IBAction func okButtonPressed() {
        MotionMeter.singleton.setOkState()
        DispatchQueue.main.async { [weak self] in
            self?.dismiss()
        }
    }
    
}

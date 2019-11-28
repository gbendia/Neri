import UIKit

class PairingCodeViewController: UIViewController {
    
    @IBOutlet weak var pairingCodeLabel: UILabel!
    
    var pairingCodeUpdatingTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairingCodeUpdatingTimer = Timer.scheduledTimer(timeInterval: TimeInterval(PAIRING_CODE_VALID_PERIOD), target: self, selector: #selector(updatePairingCode), userInfo: nil, repeats: true)
        
        pairingCodeUpdatingTimer?.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pairingCodeUpdatingTimer?.invalidate()
    }
    
    @objc func updatePairingCode() {
        let newCode = PairingCodeGenerator.generate()
        
        // Update code on database
        
        DispatchQueue.main.async {
            self.pairingCodeLabel.text = newCode
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        // Delete from database
        
        self.dismiss(animated: true)
    }
    
}

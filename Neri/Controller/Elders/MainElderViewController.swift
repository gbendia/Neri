import Foundation
import UIKit
import MapKit

class MainElderViewController: UIViewController {
    
    var updateInfoTimer: Timer?
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heartRateView: UIView!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var motionView: UIView!
    @IBOutlet weak var motionImage: UIImageView!
    @IBOutlet weak var motionLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        nameLabel.text = Elder.singleton.name
        ageLabel.text = String(Elder.singleton.age())
        
        ElderMonitor().start()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateInfoTimer = Timer.scheduledTimer(timeInterval: TimeInterval(ELDER_INFO_UPDATE_INTERVAL), target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
        
        updateInfoTimer?.fire()
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        updateInfoTimer?.invalidate()
        
        super.viewDidDisappear(animated)
    }
    
    private func setHeartRateDataView() {
        if (Elder.singleton.heartRate > -1) {
            // Change to red if dangerous
            heartRateLabel.text = String(Elder.singleton.heartRate)
        }
    }
    
    private func setMotionDataView() {
        if (Elder.singleton.fallDetected) {
            motionImage.image = UIImage(named: "alert")
            motionLabel.text = "Fall detected!"
            motionView.backgroundColor = UIColor.red
        } else {
            motionImage.image = UIImage(named: "standing")
            motionLabel.text = "Normal motion data"
            motionView.backgroundColor = UIColor.clear
        }
    }
    
    private func setLocationView() {
        // TODO
    }
    
    @objc private func updateView() {
        setHeartRateDataView()
        setMotionDataView()
        setLocationView()
    }
    
}

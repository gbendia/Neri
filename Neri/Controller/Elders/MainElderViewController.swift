import Foundation
import UIKit
import MapKit

class MainElderViewController: UIViewController, ElderMonitorDelegate {
    
    var updateInfoTimer: Timer?
    let monitor = ElderMonitor()
    
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
        ageLabel.text = "\(Elder.singleton.age()) years"
        
        monitor.setDelegate(delegate: self)
        monitor.start()
        
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
    
    @objc private func updateView() {
        setHeartRateDataView()
        setMotionDataView()
    }
    
    func didUpdate(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        monitor.getLocationAddress(completionHandler: { address in
            annotation.title = address
            self.map.removeAnnotations(self.map.annotations)
            self.map.addAnnotation(annotation)
            let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 300, longitudinalMeters: 300)
            self.map.setRegion(viewRegion, animated: false)
        })
    }
    
    @IBAction func callButtonPressed(_ sender: Any) {
        if (!Elder.singleton.emergencyPhone.isEmpty) {
            if let number = URL(string: "tel://\(Elder.singleton.emergencyPhone)") {
                UIApplication.shared.open(number)
            }
        }
    }
    
}

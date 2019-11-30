import Foundation
import UIKit
import MapKit

class MonitoringViewController: UIViewController {
    
    private var updateInfoTimer: Timer?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heartRateView: UIView!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var motionView: UIView!
    @IBOutlet weak var motionImage: UIImageView!
    @IBOutlet weak var motionLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = Elder.singleton.name
        ageLabel.text = "\(Elder.singleton.age()) years"
        
        self.updateView()
        
        updateInfoTimer = Timer.scheduledTimer(timeInterval: TimeInterval(ELDER_INFO_UPDATE_INTERVAL), target: self, selector: #selector(updateMonitoring), userInfo: nil, repeats: true)
        
        updateInfoTimer?.fire()
    }
    
    private func updateView() {
        self.updateMap()
        self.updateHeartRate()
        self.updateMotion()
    }
    
    private func updateMap() {
        print("Updating map")
        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(Elder.singleton.latitude)!, longitude: CLLocationDegrees(Elder.singleton.longitude)!)
        annotation.coordinate = location
        LocationHelper.getAddressFrom(latitude: Elder.singleton.latitude, withLongitude: Elder.singleton.longitude, completionHandler: { address in
            annotation.title = address
            self.map.removeAnnotations(self.map.annotations)
            self.map.addAnnotation(annotation)
            let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 300, longitudinalMeters: 300)
            self.map.setRegion(viewRegion, animated: false)
        })
    }
    
    private func updateHeartRate() {
        print("Updating heart rate")
        if (Elder.singleton.heartRate > -1) {
            if (HeartRateMonitor().dangerousHeartRate(for: Elder.singleton)) {
                heartRateView.backgroundColor = .red
                heartRateLabel.textColor = .red
            } else {
                heartRateView.backgroundColor = .clear
                heartRateLabel.textColor = UIColor(displayP3Red: 63, green: 144, blue: 159, alpha: 1)
            }
            heartRateLabel.text = String(Elder.singleton.heartRate)
        }
    }
    
    private func updateMotion() {
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
    
    @objc private func updateMonitoring() {
        ElderDAO.getElder(completionHandler: { _ in
            self.updateView()
        })
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        ElderDAO.getElder(completionHandler: { _ in
            self.performSegue(withIdentifier: "showElderInfo", sender: self)
        })
    }
    
    @IBAction func callButtonPressed(_ sender: Any) {
        if let number = URL(string: "tel://\(Elder.singleton.phoneNumber)") {
            UIApplication.shared.open(number)
        }
    }
    
}

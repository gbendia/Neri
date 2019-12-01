import Foundation
import UIKit
import MapKit

class MainElderViewController: UIViewController, NeriWatchConnectivityDelegate, ElderMonitorDelegate {
    
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
        super.viewDidLoad()
        
        nameLabel.text = Elder.singleton.name
        ageLabel.text = "\(Elder.singleton.age()) years"
        
        monitor.setDelegate(delegate: self)
        monitor.start()
        
        setMotionDataView()
        
        WatchConncetivityReceiver.singleton.setDelegate(self)
    }
    
    private func setNilHeartRateView() {
        DispatchQueue.main.async {
            self.heartRateView.backgroundColor = .clear
            self.heartRateLabel.text = "-"
        }
    }
    
    private func setNormalHeartRateView() {
        if (Elder.singleton.heartRate < 0) {
            return
        }
        
        print("Should set normal heart rate to [\(Elder.singleton.heartRate)]")
        DispatchQueue.main.async {
            self.heartRateView.backgroundColor = .clear
            self.heartRateLabel.text = String(Elder.singleton.heartRate)
        }
    }
    
    private func setDangerousHeartRateView() {
        if (Elder.singleton.heartRate < 0) {
            return
        }
        
        print("Should set dangerous heart rate")
        DispatchQueue.main.async {
            self.heartRateView.backgroundColor = UIColor(red: 255/255, green: 119/255, blue: 105/255, alpha: 1)
            self.heartRateLabel.text = String(Elder.singleton.heartRate)
        }
    }
    
    private func setMotionDataView() {
        DispatchQueue.main.async {
            if (Elder.singleton.fallDetected) {
                self.motionImage.image = UIImage(named: "alert")
                self.motionLabel.text = "Fall detected!"
                self.motionView.backgroundColor = UIColor(red: 255/255, green: 119/255, blue: 105/255, alpha: 1)
            } else {
                self.motionImage.image = UIImage(named: "standing")
                self.motionLabel.text = "Normal motion data"
                self.motionView.backgroundColor = UIColor.clear
            }
        }
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
    
    func fallDetectedDidChange() {
        setMotionDataView()
    }
    
    func didReceiveHeartRate(_ heartRate: Int) {
        if (heartRate == Elder.singleton.heartRate) {
            return
        }
        
        Elder.singleton.heartRate = heartRate
        ElderDAO.updateElder()
        
        if (Elder.singleton.heartRate < 0) {
            print("Setting nil heart rate")
            setNilHeartRateView()
        }
        
        if (HeartRateMonitor().hasDangerousHeartRate(for: Elder.singleton)) {
            print("Setting dangerous heart rate")
            setDangerousHeartRateView()
        } else {
            print("Setting normal heart rate")
            setNormalHeartRateView()
        }
    }
    
    func didReceiveFallDetected(_ fallDetected: Bool) {
        if (fallDetected == Elder.singleton.fallDetected) {
            return
        }
        
        Elder.singleton.fallDetected = fallDetected
        ElderDAO.updateElder()
        fallDetectedDidChange()
    }
    
    @IBAction func callButtonPressed(_ sender: Any) {
        if (!Elder.singleton.emergencyPhone.isEmpty) {
            if let number = URL(string: "tel://\(Elder.singleton.emergencyPhone)") {
                UIApplication.shared.open(number)
            }
        }
    }
    
}

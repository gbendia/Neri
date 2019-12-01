import Foundation
import MapKit

class LocationMonitor: NSObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager
    private var delegate: LocationMonitorDelegate?
    
    override init() {
        self.locationManager = CLLocationManager()
    }
    
    func setDelegate(_ delegate: LocationMonitorDelegate) {
        self.delegate = delegate
    }
    
    func start() {
        // Ask for Authorisation from the User.
        if (CLLocationManager.locationServicesEnabled()) {
            print("Asking permission")
            self.locationManager.requestAlwaysAuthorization()
        }
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        } else {
            print("Location service not enabled")
        }
    }
    
    func getLocation() -> CLLocation? {
        return locationManager.location
    }
    
    func getAddress(completionHandler: @escaping (_ address: String) -> Void) {
        LocationHelper.getAddressFrom(latitude: String.init(format: "%f", ((locationManager.location?.coordinate.latitude)!)), withLongitude: String.init(format: "%f", ((locationManager.location?.coordinate.longitude)!)), completionHandler: completionHandler)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latitude = String.init(format: "%f", (locationManager.location?.coordinate.latitude)!)
        let longitude = String.init(format: "%f", (locationManager.location?.coordinate.longitude)!)
        
        Elder.singleton.latitude = latitude
        Elder.singleton.longitude = longitude
        
        ElderDAO.updateElder()
            
        self.delegate!.didUpdate(location: location)
    }
    
}

protocol LocationMonitorDelegate {
    func didUpdate(location: CLLocationCoordinate2D)
}

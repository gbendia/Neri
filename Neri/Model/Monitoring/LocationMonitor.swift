import Foundation
import MapKit

class LocationMonitor: NSObject, Monitor, CLLocationManagerDelegate {
    
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
        self.locationManager.requestAlwaysAuthorization()
        print("Asking permission")
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            print("Not enabled")
        }
    }
    
    func getLocation() -> CLLocation? {
        return locationManager.location
    }
    
    func getAddress(completionHandler: @escaping (_ address: String) -> Void) {
        getAddressFrom(latitude: String.init(format: "%f", ((locationManager.location?.coordinate.latitude)!)), withLongitude: String.init(format: "%f", ((locationManager.location?.coordinate.longitude)!)), completionHandler: completionHandler)
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
    
    private func getAddressFrom(latitude pdblLatitude: String, withLongitude pdblLongitude: String, completionHandler: @escaping (_ address: String) -> Void) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        
        let geo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        geo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    print(addressString)
                    completionHandler(addressString)
                }
        })
    }
    
}

protocol LocationMonitorDelegate {
    func didUpdate(location: CLLocationCoordinate2D)
}

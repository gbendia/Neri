import Foundation

class ElderMonitor {
    
    let locationMonitor = LocationMonitor()
    private var delegate: ElderMonitorDelegate?
    
    func setDelegate(delegate: ElderMonitorDelegate) {
        self.delegate = delegate
        locationMonitor.setDelegate(delegate)
    }
    
    func start() {
        locationMonitor.start()
    }
    
    func getLocationAddress(completionHandler: @escaping (_ address: String) -> Void) {
        locationMonitor.getAddress(completionHandler: completionHandler)
    }
    
}

protocol ElderMonitorDelegate: LocationMonitorDelegate {

}

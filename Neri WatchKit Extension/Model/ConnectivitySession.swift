import Foundation
import WatchConnectivity

class ConnectivitySession: NSObject, WCSessionDelegate {
    
    static let singleton = ConnectivitySession()

    private var isActive = false
    
    override private init() {
        super.init()
    }
    
    private let connectivitySession = WCSession.default
    
    func startConnection() {
        if (isActive) {
            return
        }
        
        self.isActive = true
        connectivitySession.delegate = self
        connectivitySession.activate()
    }
    
    func sendData(_ key: String, _ value: Any) {
        if (!isActive) {
            return
        }
        
        print("Sending [\(key): \(value)]")
        let dataToBeSent: [String: Any] = [key: value]
        connectivitySession.transferUserInfo(dataToBeSent)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Connection did complete with [activationState: \(activationState)]")
    }
    
}

import Foundation
import WatchConnectivity

class WatchConncetivityReceiver: NSObject, WCSessionDelegate {
    
    static let singleton = WatchConncetivityReceiver()
    private var delegate: NeriWatchConnectivityDelegate?
    private var connectivitySession: WCSession?
    
    override private init() {
        super.init()
        if WCSession.isSupported() {
            connectivitySession = WCSession.default
            connectivitySession?.delegate = self
            connectivitySession?.activate()
        }
    }
    
    func setDelegate(_ delegate: NeriWatchConnectivityDelegate) {
        self.delegate = delegate
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Watch connectivity session did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Watch connectivity session did deactivate")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("Did receive data")
        if let heartRate = userInfo["heartRate"] {
            print("Received heart rate")
            let heartRateValue = heartRate as! Int
            self.delegate!.didReceiveHeartRate(heartRateValue)
        } else if let fallDetected = userInfo["fallDetected"] {
            print("Received fall detection")
            let fallDetectedValue = fallDetected as! Bool
            self.delegate!.didReceiveFallDetected(fallDetectedValue)
        }
    }
    
}

protocol NeriWatchConnectivityDelegate {
    func didReceiveHeartRate(_ heartRate: Int)
    func didReceiveFallDetected(_ fallDetected: Bool)
}

import Foundation
import UIKit

class Caregiver {
    
    static let singleton = Caregiver()
    
    var phoneNumber: String = ""
    var connectedEldersIDs: [String] = [String]() // List of the elders IDs on Firestore
    
    private init() {}
    
    func addPairing(with code: String, onSuccess: @escaping () -> Void, onInvalidCode: @escaping () -> Void) {
        ElderDAO.findElderWith(pairingCode: code, completionHandler: { elderID in
            Caregiver.singleton.connectedEldersIDs.append(elderID)
            
            CaregiverDAO.updateCaregiver {
                onSuccess()
            }
        }, onInvalidCode: {
            onInvalidCode()
        })
    }
    
    func connect(with elderID: String, completionHandler: @escaping () -> Void) {
        ElderDAO.getElder(id: elderID, completionHandler: { _ in
            completionHandler()
        })
    }
    
}

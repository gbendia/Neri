import Foundation

class CaregiverDAO: NeriDAO {
    
    let dao = CaregiverDAO()
    
    private override init() {}
    
    private static var caregiverID: String? = nil
    
    private static let CAREGIVER_COLLECTION = "caregivers"
    
    static func createCaregiver(completionHandler: @escaping () -> Void = {}) {
        let caregiverData: [String: Any] = ["phone": Caregiver.singleton.phoneNumber,
                                            "connectedEldersIDs": Caregiver.singleton.connectedEldersIDs]
        
        let documentID = save(collection: CAREGIVER_COLLECTION, data: caregiverData, completionHandler: completionHandler)
        if (documentID != nil) {
            caregiverID = documentID
            saveIDLocally()
        }
    }
    
    static func updateCaregiver(completionHandler: @escaping () -> Void = {}) {
        if (caregiverID != nil) {
            let caregiverData: [String:Any] = ["phone": Caregiver.singleton.phoneNumber,
                                               "connectedEldersIDs": Caregiver.singleton.connectedEldersIDs]
            
            update(collection: CAREGIVER_COLLECTION, data: caregiverData, id: caregiverID!, completionHandler: completionHandler)
        }
    }
    
    static func getCaregiver(completionHandler: @escaping () -> Void = {}) {
        if (caregiverID != nil) {
            getDocumentByID(collection: CAREGIVER_COLLECTION, id: caregiverID!, completionHandler: { caregiverDocument in
                self.setCaregiverSingletonAttributes(from: caregiverDocument)
                completionHandler()
            })
        }
    }
    
    private static func setCaregiverSingletonAttributes(from document: [String: Any]) {
        Caregiver.singleton.phoneNumber = document["phone"] as! String
        Caregiver.singleton.connectedEldersIDs = document["connectedEldersIDs"] as! [String]
    }
    
    private static func saveIDLocally() {
        let defaults = UserDefaults.standard
        defaults.set(caregiverID, forKey: "currentCaregiverID")
    }
    
    static func getCurrentCaregiver(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        let defaults = UserDefaults.standard
        if let caregiverID = defaults.string(forKey: "currentCaregiverID") {
            print("Found caregiver with [ID:\(caregiverID)]")
            self.caregiverID = caregiverID
            self.getCaregiver {
                onSuccess()
            }
            return
        } else {
            print("No caregiver currently selected")
            onFailure()
        }
    }
    
}

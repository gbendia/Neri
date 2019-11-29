import Foundation

class ElderDAO: NeriDAO {
    
    let dao = ElderDAO()
    
    private override init() {}
    
    private static var elderID: String? = nil
    
    private static let ELDER_COLLECTION = "elders"
    
    static func createElder(completionHandler: @escaping () -> Void = {}) {
        let elderData: [String:Any] = ["name": Elder.singleton.name,
                                       "birthday": DateHelper.stringFrom(date: Elder.singleton.birthday, as: DateHelper.DATE_ONLY_FORMAT),
                                       "weight": Elder.singleton.weight,
                                       "height": Elder.singleton.height,
                                       "address": Elder.singleton.address,
                                       "city": Elder.singleton.city,
                                       "state": Elder.singleton.state,
                                       "phoneNumber": Elder.singleton.phoneNumber,
                                       "emergencyPhone": Elder.singleton.emergencyPhone,
                                       "heartRate": Elder.singleton.heartRate,
                                       "location": ["latitude": Elder.singleton.latitude,
                                                    "longitude": Elder.singleton.longitude],
                                       "fallDetected": Elder.singleton.fallDetected,
                                       "pairingCode": ["code": Elder.singleton.pairingCode,
                                                       "codeCreatedAt": DateHelper.stringFrom(date: Elder.singleton.codeCreatedAt, as: DateHelper.DATE_TIME_FORMAT)]]
        
        let documentID = save(collection: ELDER_COLLECTION, data: elderData, completionHandler: completionHandler)
        if (documentID != nil) {
            elderID = documentID
            saveIDLocally()
        }
    }
    
    static func updateElder(completionHandler: @escaping () -> Void = {}) {
        if (elderID != nil) {
            let elderData: [String:Any] = ["name": Elder.singleton.name,
                                           "birthday": DateHelper.stringFrom(date: Elder.singleton.birthday, as: DateHelper.DATE_ONLY_FORMAT),
                                           "weight": Elder.singleton.weight,
                                           "height": Elder.singleton.height,
                                           "address": Elder.singleton.address,
                                           "city": Elder.singleton.city,
                                           "state": Elder.singleton.state,
                                           "phoneNumber": Elder.singleton.phoneNumber,
                                           "emergencyPhone": Elder.singleton.emergencyPhone,
                                           "heartRate": Elder.singleton.heartRate,
                                           "location": ["latitude": Elder.singleton.latitude,
                                                        "longitude": Elder.singleton.longitude],
                                           "fallDetected": Elder.singleton.fallDetected,
                                           "pairingCode": ["code": Elder.singleton.pairingCode,
                                                           "codeCreatedAt": DateHelper.stringFrom(date: Elder.singleton.codeCreatedAt, as: DateHelper.DATE_TIME_FORMAT)]]
            
            update(collection: ELDER_COLLECTION, data: elderData, id: elderID!, completionHandler: completionHandler)
        }
    }
    
    static func getElder(id: String? = elderID, completionHandler: @escaping () -> Void = {}) {
        if (id != nil) {
            getDocumentByID(collection: ELDER_COLLECTION, id: id!, completionHandler: { elderDocument in
                self.setElderSingletonAttributes(from: elderDocument)
                completionHandler()
            })
        }
    }
    
    static func findElderWith(pairingCode code: String, completionHandler: @escaping (String) -> Void = {_ in }, onInvalidCode: @escaping () -> Void = {}) {
        queryDocumentByField(collection: ELDER_COLLECTION, queryField: "pairingCode", queryValue: code) { elderDocuments in
            for document in elderDocuments {
                let codeCreatedAt = DateHelper.dateFrom(string: (document["pairingCode"] as! [String: Any])["codeCreatedAt"] as! String, format: DateHelper.DATE_TIME_FORMAT)
                if (Elder.pairingCodeIsValid(codeCreatedAt: codeCreatedAt)) {
                    self.elderID = document["documentID"] as? String
                    self.setElderSingletonAttributes(from: document)
                    if (Elder.singleton.pairingCodeIsValid()) {
                        self.saveIDLocally()
                        completionHandler(elderID!)
                    } else {
                        onInvalidCode()
                    }
                }
            }
        }
    }
    
    private static func setElderSingletonAttributes(from document: [String: Any]) {
        // Setting personal information
        Elder.singleton.name = document["name"] as! String
        Elder.singleton.birthday = DateHelper.dateFrom(string: document["birthday"] as! String, format: DateHelper.DATE_ONLY_FORMAT)
        Elder.singleton.weight = document["weight"] as! String
        Elder.singleton.height = document["height"] as! String
        Elder.singleton.address = document["address"] as! String
        Elder.singleton.city = document["city"] as! String
        Elder.singleton.state = document["state"] as! String
        Elder.singleton.phoneNumber = document["phoneNumber"] as! String
        Elder.singleton.emergencyPhone = document["emergencyPhone"] as! String
        
        // Setting tracking information
        Elder.singleton.heartRate = document["heartRate"] as! Int
        let location = (document["location"] as! [String: String])
        Elder.singleton.latitude = location["latitude"]!
        Elder.singleton.longitude = location["longitude"]!
        Elder.singleton.fallDetected = document["fallDetected"] as! Bool
        
        // Setting pairing code information
        let pairingCode = document["pairingCode"] as! [String: String]
        Elder.singleton.pairingCode = pairingCode["code"]!
        Elder.singleton.codeCreatedAt = DateHelper.dateFrom(string: pairingCode["codeCreatedAt"]!, format: DateHelper.DATE_TIME_FORMAT)
    }
    
    private static func saveIDLocally() {
        let defaults = UserDefaults.standard
        defaults.set(elderID, forKey: "currentElderID")
    }
    
    static func getCurrentElder(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        let defaults = UserDefaults.standard
        if let elderID = defaults.string(forKey: "currentElderID") {
            print("Found elder with [ID:\(elderID)]")
            self.elderID = elderID
            self.getElder {
                onSuccess()
            }
            return
        } else {
            print("No elder currently selected")
            onFailure()
        }
    }
    
}

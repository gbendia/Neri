import Foundation

class ElderDAO: NeriDAO {
    
    private var elderID: String? = nil
    
    private let ELDER_COLLECTION = "elders"
    
    func saveElder() {
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
//                                       "location": ...,
                                        "fallDetected": Elder.singleton.fallDetected,
                                        "pairingCode": ["code": Elder.singleton.pairingCode,
                                                        "codeCreatedAt": DateHelper.stringFrom(date: Elder.singleton.codeCreatedAt, as: DateHelper.DATE_TIME_FORMAT)]]
        
        let document = save(collection: ELDER_COLLECTION, data: elderData, completionHandler: logSaveEvent)
        if (document != nil) {
            elderID = document!.documentID
            saveIDLocally()
        }
    }
    
    func updateElder() {
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
//                                       "location": ...,
                                           "fallDetected": Elder.singleton.fallDetected,
                                           "pairingCode": ["code": Elder.singleton.pairingCode,
                                                           "codeCreatedAt": DateHelper.stringFrom(date: Elder.singleton.codeCreatedAt, as: DateHelper.DATE_TIME_FORMAT)]]
            
            update(collection: ELDER_COLLECTION, data: elderData, id: elderID!, completionHandler: logUpdateEvent)
        }
    }
    
    func getElder() {
        if (elderID != nil) {
            getDocumentByID(collection: ELDER_COLLECTION, id: elderID!, completionHandler: { elderDocument in
                // Retrieving personal information
                Elder.singleton.name = elderDocument["name"] as! String
                Elder.singleton.birthday = DateHelper.dateFrom(string: elderDocument["birtday"] as! String, format: DateHelper.DATE_ONLY_FORMAT)
                Elder.singleton.weight = elderDocument["weight"] as! Float
                Elder.singleton.height = elderDocument["height"] as! Float
                Elder.singleton.address = elderDocument["address"] as! String
                Elder.singleton.city = elderDocument["city"] as! String
                Elder.singleton.state = elderDocument["state"] as! String
                Elder.singleton.phoneNumber = elderDocument["phoneNumber"] as! String
                Elder.singleton.emergencyPhone = elderDocument["emergencyPhone"] as! String
                
                // Retrieving tracking information
                Elder.singleton.heartRate = elderDocument["heartRate"] as! Int
//                Elder.singleton.location = ...
                Elder.singleton.fallDetected = elderDocument["fallDetected"] as! Bool
                
                // Retrieving pairing code information
                Elder.singleton.pairingCode = elderDocument["pairingCode"] as! String
                Elder.singleton.codeCreatedAt = DateHelper.dateFrom(string: elderDocument["codeCreatedAt"] as! String, format: DateHelper.DATE_TIME_FORMAT)
            })
        }
    }
    
    func findElderWith(pairingCode code: String) {
        
    }
    
    private func saveIDLocally() {
        
    }
    
    func logSaveEvent() {
        
    }
    
    func logUpdateEvent() {
        
    }
    
}

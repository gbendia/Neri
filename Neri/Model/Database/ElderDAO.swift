import Foundation

class ElderDAO: NeriDAO {
    
    private var elderID: String? = nil
    
    func saveElder() {
        let elderData: [String:Any] = ["name": Elder.singleton.name,
                                       "birthday": DateFormatter.localizedString(from: Elder.singleton.birthday, dateStyle: .short, timeStyle: .short),
                                       "weight": Elder.singleton.weight,
                                       "height": Elder.singleton.height,
                                       "address": Elder.singleton.address,
                                       "city": Elder.singleton.city,
                                       "state": Elder.singleton.state,
                                       "phoneNumber": Elder.singleton.phoneNumber,
                                       "emergencyPhone": Elder.singleton.emergencyPhone]
        
        let document = save(collection: "elders", data: elderData, completionHandler: logSaveEvent)
        if (document != nil) {
            elderID = document!.documentID
            saveIDLocally()
        }
    }
    
    func updateElder() {
        if (elderID != nil) {
            let elderData: [String:Any] = ["name": Elder.singleton.name,
                                           "birthday": DateFormatter.localizedString(from: Elder.singleton.birthday, dateStyle: .short, timeStyle: .short),
                                           "weight": Elder.singleton.weight,
                                           "height": Elder.singleton.height,
                                           "address": Elder.singleton.address,
                                           "city": Elder.singleton.city,
                                           "state": Elder.singleton.state,
                                           "phoneNumber": Elder.singleton.phoneNumber,
                                           "emergencyPhone": Elder.singleton.emergencyPhone]
            
            update(collection: "elders", data: elderData, id: elderID!, completionHandler: logUpdateEvent)
        }
    }
    
    func loadElder() {
        
    }
    
    func findElderWith(activeCode code: String) {
        
    }
    
    private func saveIDLocally() {
        
    }
    
    func logSaveEvent() {
        
    }
    
    func logUpdateEvent() {
        
    }
    
}

import Foundation

class Caregiver {
    
    static let singleton = Caregiver()
    
    var phoneNumber: String = ""
    var connectedEldersIDs: [String] = [String]() // List of the elders IDs on Firestore
    
    private init() {}
    
}

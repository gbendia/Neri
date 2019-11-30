import Foundation
import UIKit

class Caregiver {
    
    static let singleton = Caregiver()
    
    var phoneNumber: String = ""
    var connectedEldersIDs: [String] = [String]() // List of the elders IDs on Firestore
    private static var names = [String]()
    
    private init() {}
    
    private static func getEldersNames() -> [String] {
        return self.names
    }
    
}

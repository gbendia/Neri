import Foundation
import UIKit

class Elder {
    
    static let singleton = Elder()
    
    // MARK: - Personal Information
    var name: String = ""
    var birthday: Date = Date()
    var weight: String = ""
    var height: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var phoneNumber: String = ""
    var emergencyPhone: String = ""
    
    // MARK: - Tracking Information
    var heartRate: Int = -1
    var latitude: String = ""
    var longitude: String = ""
    var fallDetected: Bool = false
    
    // MARK: - Pairing Code
    var pairingCode: String = ""
    var codeCreatedAt: Date = Date()
    
    private init() {}
    
    func age() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self.birthday, to: now)
        return ageComponents.year!
    }
    
    func pairingCodeIsValid() -> Bool {
        let expirationDate = codeCreatedAt.addingTimeInterval(PAIRING_CODE_VALID_PERIOD)
        return expirationDate > Date()
    }
    
    static func pairingCodeIsValid(codeCreatedAt: Date) -> Bool {
        let expirationDate = codeCreatedAt.addingTimeInterval(PAIRING_CODE_VALID_PERIOD)
        return expirationDate > Date()
    }
    
}

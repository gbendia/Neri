import Foundation

protocol Validator {
    static func isValid(_ string: String) -> Bool
}

class PhoneValidator: Validator {
    private let phoneRegex = ""
    
    static func isValid(_ string: String) -> Bool {
        return true
    }
}

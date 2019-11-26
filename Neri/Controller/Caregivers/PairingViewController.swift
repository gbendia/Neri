import UIKit

class PairingViewController: BasicFormViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var pairingCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func hasEmptyFields() -> Bool {
        let emptyPhoneNumber = phoneNumberTextField.text?.isEmpty
        let emptyPairingCode = pairingCodeTextField.text?.isEmpty
        
        if (emptyPhoneNumber! || emptyPairingCode!) {
            return true
        }
        
        return false
    }
    
    private func hasValidPairingCode() -> Bool {
        // Checar codigo no banco
        return false
    }
    
    private func hasValidPhoneNumber() -> Bool {
        return PhoneValidator.isValid(phoneNumberTextField.text!)
    }
    
    @IBAction func codeWillChange(_ sender: Any) {
        print("test")
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        if (hasEmptyFields()) {
            showEmptyFieldAlert()
            return
        }
        
        var invalidFields = [String]()
        if (!hasValidPairingCode()) {
            invalidFields.append("\"Pairing Code\"")
        }
        if (!hasValidPhoneNumber()) {
            invalidFields.append("\"Phone Number\"")
        }
        if (!invalidFields.isEmpty) {
            showInvalidFieldAlert(for: invalidFields)
        }
        
        // Salvar dados no banco
        // Checar cadastro no banco
        
        performSegue(withIdentifier: "goToEldersView", sender: self)
    }
    
}

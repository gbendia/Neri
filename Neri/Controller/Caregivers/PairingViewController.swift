import UIKit

class PairingViewController: BasicFormViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var pairingCodeTextField: UITextField!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappingOutsideTextField()
        
        loadingView.isHidden = true
        activityIndicator.isHidden = true
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
        ElderDAO.findElderWith(pairingCode: pairingCodeTextField.text!, completionHandler: {_ in 
            
        }, onInvalidCode: {
            
        })
        return false
    }
    
    private func hasValidPhoneNumber() -> Bool {
        return PhoneValidator.isValid(phoneNumberTextField.text!)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        if (hasEmptyFields()) {
            showEmptyFieldAlert()
            return
        }
        
        var invalidFields = [String]()
        if (!hasValidPhoneNumber()) {
            invalidFields.append("\"Phone number\"")
        }
        if (!hasValidPairingCode()) {
            invalidFields.append("\"Pairing code\"")
        }
        if (!invalidFields.isEmpty) {
            showInvalidFieldAlert(for: invalidFields)
            return
        }
        
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        
        ElderDAO.findElderWith(pairingCode: pairingCodeTextField.text!, completionHandler: { elderID in
            Caregiver.singleton.phoneNumber = self.phoneNumberTextField.text!
            Caregiver.singleton.connectedEldersIDs.append(elderID)
            self.loadingView.isHidden = true
            self.activityIndicator.isHidden = true
            self.performSegue(withIdentifier: "goToEldersView", sender: self)
        }, onInvalidCode: {
            self.loadingView.isHidden = true
            self.activityIndicator.isHidden = true
            self.showInvalidFieldAlert(for: ["\"Pairing code\""])
        })
        
        // Salvar dados no banco
        // Checar cadastro no banco
    }
    
}

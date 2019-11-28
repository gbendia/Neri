import UIKit

class ElderSignUpViewController: BasicFormViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    private var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [nameTextField,
                      birthdayTextField,
                      weightTextField,
                      addressTextField,
                      cityTextField,
                      stateTextField,
                      phoneNumberTextField]
        
        hideKeyboardWhenTappingOutsideTextField()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func hasEmptyFields() -> Bool {
        for textField in textFields {
            if (textField.text?.isEmpty ?? true) {
                return true
            }
        }
        return false
    }
    
    private func getInvalidFields() -> [String] {
        var invalidFields = [String]()
        if (!PhoneValidator.isValid(phoneNumberTextField.text!)) {
            invalidFields.append("Phone number")
        }
        if (!DateValidator.isValid(birthdayTextField.text!)) {
            invalidFields.append("Date of birth")
        }
        
        return invalidFields
    }
    
    @IBAction func addPhotoClicked(_ sender: Any) {
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        if (hasEmptyFields()) {
            showEmptyFieldAlert()
            return
        }
        
        let invalidFields = getInvalidFields()
        if (invalidFields.count > 0) {
            showInvalidFieldAlert(for: invalidFields)
            return
        }
        
        // Fill and save elder
        Elder.singleton.name = nameTextField.text!
        Elder.singleton.birthday = DateHelper.dateFrom(string: birthdayTextField.text!, format: DateHelper.DATE_ONLY_FORMAT)
        Elder.singleton.weight = (weightTextField.text! as NSString).floatValue
        Elder.singleton.height = (heightTextField.text! as NSString).floatValue
        Elder.singleton.address = addressTextField.text!
        Elder.singleton.city = cityTextField.text!
        Elder.singleton.state = stateTextField.text!
        Elder.singleton.phoneNumber = phoneNumberTextField.text!
        
        performSegue(withIdentifier: "goToPairingCode", sender: self)
    }
}

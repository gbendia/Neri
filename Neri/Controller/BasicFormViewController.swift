import UIKit

class BasicFormViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showEmptyFieldAlert() {
        showCustomAlertWithOKOption("Empty field", "Please fill every fields with valid values before continuing")
    }
    
    func showInvalidFieldAlert(for fields: Array<String>) {
        if (fields.isEmpty) {
            return
        }
        
        if (fields.count == 1) {
            showCustomAlertWithOKOption("Invalid field", "The field \(fields[0]) was not filled with a valid value")
        } else {
            var auxFields = fields
            var message = "The fields \(auxFields[0])"
            auxFields.removeFirst()
            for field in auxFields {
                if (field == auxFields.last) {
                    message.append(" and \(field)")
                } else {
                    message.append(", \(field)")
                }
            }
            message.append(" were not filled with valid values")
            showCustomAlertWithOKOption("Invalid fields", message)
        }
    }
    
    private func showCustomAlertWithOKOption(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}

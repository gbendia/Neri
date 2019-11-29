import Foundation
import UIKit

class EditElderViewController: BasicFormViewController {
    
    var pairingCodeUpdatingTimer: Timer?
    
    var editableFields = [UITextField]()
    var labelsList = [UILabel]()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emergencyPhoneLabel: UILabel!
    @IBOutlet weak var pairingCodeLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        editButton.isHidden = false
        confirmButton.isHidden = true
        
        labelsList.append(birthdayLabel)
        labelsList.append(weightLabel)
        labelsList.append(heightLabel)
        labelsList.append(streetLabel)
        labelsList.append(cityLabel)
        labelsList.append(phoneLabel)
        labelsList.append(emergencyPhoneLabel)
        
        for label in labelsList {
            let textField = UITextField(frame: label.frame)
            textField.backgroundColor = UIColor.clear
            textField.textColor = UIColor.white
            textField.isUserInteractionEnabled = true
            textField.textAlignment = NSTextAlignment.left
            textField.font = label.font
            editableFields.append(textField)
            textField.isHidden = true
            label.isHidden = false
            label.superview!.addSubview(textField)
        }
        
        hideKeyboardWhenTappingOutsideTextField()
        
        pairingCodeUpdatingTimer = Timer.scheduledTimer(timeInterval: TimeInterval(PAIRING_CODE_VALID_PERIOD), target: self, selector: #selector(updatePairingCode), userInfo: nil, repeats: true)
        
        pairingCodeUpdatingTimer?.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pairingCodeUpdatingTimer?.invalidate()
    }
    
    private func setView() {
        // set photo
        nameLabel.text = Elder.singleton.name
        ageLabel.text = String(Elder.singleton.age())
        birthdayLabel.text = DateHelper.stringFrom(date: Elder.singleton.birthday, as: DateHelper.DATE_ONLY_FORMAT)
        weightLabel.text = Elder.singleton.weight
        heightLabel.text = Elder.singleton.height
        streetLabel.text = Elder.singleton.address
        cityLabel.text = Elder.singleton.city
        phoneLabel.text = Elder.singleton.phoneNumber
        emergencyPhoneLabel.text = Elder.singleton.emergencyPhone
        
        confirmButton.imageView!.frame = CGRect(x: 25, y: 0, width: 15, height: 40)
    }
    
    private func getLabelRect(_ label: UILabel) -> CGRect {
        return CGRect(x: 0, y: 0, width: label.frame.width, height: label.frame.height)
    }
    
    private func startEditing() {
        editButton.isHidden = true
        confirmButton.isHidden = false
        
        for i in 0...labelsList.count-1 {
            self.editableFields[i].text = self.labelsList[i].text
            self.labelsList[i].isHidden = true
            self.editableFields[i].isHidden = false
        }
    }
    
    private func endEditing() {
        editButton.isHidden = false
        confirmButton.isHidden = true
        
        for i in 0...labelsList.count-1 {
            self.labelsList[i].text = self.editableFields[i].text!
            self.editableFields[i].isHidden = true
            self.labelsList[i].isHidden = false
        }
    }
    
    @objc func updatePairingCode() {
        let newCode = PairingCodeGenerator.generate()
        Elder.singleton.pairingCode = newCode
        Elder.singleton.codeCreatedAt = Date()
        
        ElderDAO.updateElder()
        
        DispatchQueue.main.async {
            self.pairingCodeLabel.text = newCode
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        startEditing()
    }
    
    @IBAction func confirmEditPressed(_ sender: Any) {
        endEditing()
        
        Elder.singleton.birthday = DateHelper.dateFrom(string: birthdayLabel.text!, format: DateHelper.DATE_ONLY_FORMAT)
        ageLabel.text = String(Elder.singleton.age())
        Elder.singleton.weight = weightLabel.text!
        Elder.singleton.height = heightLabel.text!
        Elder.singleton.address = streetLabel.text!
        Elder.singleton.city = cityLabel.text!
        Elder.singleton.phoneNumber = phoneLabel.text!
        Elder.singleton.emergencyPhone = emergencyPhoneLabel.text!
        
        ElderDAO.updateElder()
    }
    
}

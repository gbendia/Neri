import Foundation
import UIKit

class ElderInfoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = Elder.singleton.name
        ageLabel.text = "\(Elder.singleton.age()) years"
        birthdayLabel.text = DateHelper.stringFrom(date: Elder.singleton.birthday, as: DateHelper.DATE_ONLY_FORMAT)
        weightLabel.text = Elder.singleton.weight
        heightLabel.text = Elder.singleton.height
        addressLabel.text = Elder.singleton.address
        cityLabel.text = Elder.singleton.city
        phoneLabel.text = Elder.singleton.phoneNumber
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

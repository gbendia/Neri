import UIKit

class EldersTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    
    func displayElder(name: String, age: Int) {
        nameLabel.text = name
        ageLabel.text = "\(age) years"
    }
    
}

import UIKit

class EldersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    
    func displayElder(name: String, age: Int) {
        nameLabel.text = name
        
    }
    
}

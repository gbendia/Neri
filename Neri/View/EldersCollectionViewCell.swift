import UIKit

class EldersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    func displayElder(photo: UIImage, name: String) {
        photoImageView.image = photo
        nameLabel.text = name
    }
    
}

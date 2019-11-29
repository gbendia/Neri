import UIKit

class EldersListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var eldersCollection: UICollectionView!
    
    var eldersPhotos = [UIImage?]()
    var eldersNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addElderPressed(_ sender: Any) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Caregiver.singleton.connectedEldersIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "elderCell", for: indexPath) as! EldersCollectionViewCell
        let photo = eldersPhotos[indexPath.row] ?? UIImage(named: "nophoto")!
        cell.displayElder(photo: photo, name: eldersNames[indexPath.row])
        
        return cell
    }
    
}

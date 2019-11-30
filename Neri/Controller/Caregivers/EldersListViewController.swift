import UIKit

class EldersListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var eldersCollection: UICollectionView!
    
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
//        cell.displayElder(name: eldersNames[indexPath.row])
        
        return cell
    }
    
}

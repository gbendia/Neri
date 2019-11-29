import UIKit

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ElderDAO.getCurrentElder(onSuccess: {
            self.performSegue(withIdentifier: "showElder", sender: self)
        }, onFailure: {
            self.performSegue(withIdentifier: "showInitial", sender: self)
        })
    }
    
}

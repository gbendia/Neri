import UIKit

class EldersListViewController: BasicFormViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var eldersTableView: UITableView!
    
    var eldersNames = [String]()
    var eldersAges = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eldersTableView.delegate = self
        eldersTableView.dataSource = self
        
        loadConnectedEldersInfo()
    }
    
    private func loadConnectedEldersInfo() {
        self.eldersNames = [String]()
        self.eldersAges = [Int]()
        for id in Caregiver.singleton.connectedEldersIDs {
            ElderDAO.getElder(id: id) { elderDict in
                self.eldersNames.append(elderDict["name"] as! String)
                let birthdayDate = DateHelper.dateFrom(string: elderDict["birthday"] as! String, format: DateHelper.DATE_ONLY_FORMAT)
                self.eldersAges.append(DateHelper.age(from: birthdayDate))
                self.eldersTableView.reloadData()
            }
        }
    }
    
    @IBAction func addElderPressed(_ sender: Any) {
        let addElderAlert = UIAlertController(title: "Pairing", message: "Please enter the person's pairing code to start pairing", preferredStyle: .alert)
        addElderAlert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Pairing code"
        }

        addElderAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak addElderAlert] (_) in
            let textField = addElderAlert?.textFields![0]
            if let pairingCode = textField?.text! {
                Caregiver.singleton.addPairing(with: pairingCode, onSuccess: self.loadConnectedEldersInfo, onInvalidCode: {
                    addElderAlert?.dismiss(animated: true)
                    self.showInvalidFieldAlert(for: ["\"Pairing code\""])
                })
            }
            
        }))
        self.present(addElderAlert, animated: true, completion: nil)
    }
    
    // MARK: - TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of connected elders: \(eldersNames.count)")
        return eldersNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "elderTableCell") as! EldersTableViewCell
        cell.displayElder(name: eldersNames[indexPath.row], age: eldersAges[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Caregiver.singleton.connect(with: Caregiver.singleton.connectedEldersIDs[indexPath.row], completionHandler: {
            self.performSegue(withIdentifier: "showElder", sender: self)
        })
    }
    
}

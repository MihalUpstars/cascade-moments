import UIKit

protocol FlagCellDelegate: AnyObject {
    func shareText(_ text: String, from cell: FlagCell)
}

class FlagViewController: UIViewController, FlagCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let indentifireHeaderCell = "HeaderFlagCell"
    let indentifire = "FlagCell"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func shareText(_ text: String, from cell: FlagCell) {
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
}

extension FlagViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let show = ShowInspiration.show ?? false
        let count = show ? 2 : 1
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: indentifireHeaderCell, for: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: indentifire, for: indexPath)
            let mainCell = cell as? FlagCell
            mainCell?.delegate = self
            mainCell?.mainView.layer.borderColor = UIColor.white.cgColor
            mainCell?.mainView.layer.borderWidth = 1

            return cell
        }
    }
}

class FlagCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    weak var delegate: FlagCellDelegate?
    var activeFlag = true
    
    @IBAction func tapFlg(_ sender: UIButton) {
        activeFlag = !activeFlag
        let img = activeFlag ? UIImage(named: "resultFlagBtnOn") : UIImage(named: "resultFlagBtn")
        sender.setImage(img, for: .normal)
        ShowInspiration.show = activeFlag
    }
    
    @IBAction func tapShare(_ sender: UIButton) {
        let resultStr = "– Just as water gradually forms cascades, small efforts can lead to great results."
        delegate?.shareText(resultStr, from: self)
    }
    
}


import UIKit

protocol GratitudeCellDelegate: AnyObject {
    func shareText(_ text: String, from cell: GratitudeCell)
}

class InfoViewController: UIViewController, GratitudeCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gratitudes = [Gratitude]()
    let indentifireHeaderCell = "HeaderCell"
    let indentifire = "GratitudeCell"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gratitudes = Gratitude.loadAll()
        tableView.reloadData()
    }
    
    func shareText(_ text: String, from cell: GratitudeCell) {
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gratitudes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: indentifireHeaderCell, for: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: indentifire, for: indexPath)
            let mainCell = cell as? GratitudeCell
            mainCell?.delegate = self
            
            let item = gratitudes[indexPath.row - 1]
            mainCell?.gratitude = item
            
            return cell
        }
    }
}

class GratitudeCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tvView: UIView!
    @IBOutlet weak var textView: UITextView!

    weak var delegate: GratitudeCellDelegate?
    
    var gratitude: Gratitude? {
        didSet {
            mainView.layer.borderColor = UIColor.white.cgColor
            mainView.layer.borderWidth = 1
            
            tvView.layer.borderColor = UIColor.white.cgColor
            tvView.layer.borderWidth = 1
            
            textView.text = gratitude?.title
            dateLabel.text = formatDate(gratitude?.date ?? Date())
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func tapShare(_ sender: UIButton) {
        let resultStr = gratitude?.title ?? ""
        delegate?.shareText(resultStr, from: self)
    }
}


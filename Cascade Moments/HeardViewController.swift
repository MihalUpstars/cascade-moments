
import UIKit

class HeardViewController: UIViewController {
    
    @IBOutlet weak var widthStone: NSLayoutConstraint!
    @IBOutlet weak var topStone: NSLayoutConstraint!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var stoneImgView: UIImageView!
    @IBOutlet weak var finishDescrView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tvView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    
    let screenHeight = UIScreen.main.bounds.height
    var calculatedHeight: CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.borderColor = UIColor.white.cgColor
        mainView.layer.borderWidth = 1
        
        tvView.layer.borderColor = UIColor.white.cgColor
        tvView.layer.borderWidth = 1
        
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow(_:)),
          name: UIResponder.keyboardWillShowNotification,
          object: nil)
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide(_:)),
          name: UIResponder.keyboardWillHideNotification,
          object: nil)
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(tapView))
        view.addGestureRecognizer(gr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restartScreen()
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        setSendBtn(enablet: false)
        UIView.animate(withDuration: 1, animations: {
            self.topStone.constant = 100 / self.calculatedHeight
            self.view.layoutIfNeeded()
        })
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        setSendBtn(enablet: true)
        UIView.animate(withDuration: 1, animations: {
            self.topStone.constant = 220 / self.calculatedHeight
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func tapView() {
        view.endEditing(true)
    }
    
    private func restartScreen() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let screenScale = UIScreen.main.scale

        let screenHeightInInches = screenHeight / screenScale / 163
        let screenWidthInInches = screenWidth / screenScale / 163
        let screenDiagonal = sqrt(pow(screenHeightInInches, 2) + pow(screenWidthInInches, 2))

        let cof: CGFloat = screenDiagonal < 5.4 ? 400 : 812
        
        calculatedHeight = screenHeight / cof//812
        widthStone.constant = 124
        topStone.constant = 220 / calculatedHeight
        stoneImgView.alpha = 1
        finishDescrView.alpha = 0
        
        mainView.isHidden = false
        setTextView(textView: textView, text: "Write here...", font: UIFont.systemFont(ofSize: 22, weight: .light))
        setSendBtn(enablet: false)

    }
    
    private func setTextView(textView: UITextView, text: String, font: UIFont) {
        let color = text == "Write here..." ? UIColor.placeholderText : .white
        textView.attributedText = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: color,
                         .font: font]
        )
    }
    
    private func setSendBtn(enablet: Bool) {
        let enablet = textView.text != "Write here..." && enablet
        sendBtn.isEnabled = enablet
        let alpha = enablet ? 1 : 0.5
        sendBtn.alpha = alpha
    }
    
    private func animationStoneВecrease() {
        UIView.animate(withDuration: 1, animations: {
            self.topStone.constant = 500 * self.calculatedHeight
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.animationStoneFall()
        })
    }
    
    private func animationStoneFall() {
        UIView.animate(withDuration: 6, animations: {
            self.topStone.constant = 440 * self.calculatedHeight
            self.widthStone.constant = 10
            self.stoneImgView.alpha = 0
            self.finishDescrView.alpha = 1
            self.view.layoutIfNeeded()
        })
    }

  
    @IBAction func tapSend(_ sender: UIButton) {
        var gratitude = Gratitude()
        gratitude.title = textView.text
        gratitude.date = Date()
        Gratitude.add(gratitude)
        
        mainView.isHidden = true
        animationStoneВecrease()
    }
}

extension HeardViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write here..." {
            textView.text = ""
        }
        
        setTextView(textView: textView, text: textView.text, font: UIFont.systemFont(ofSize: 22, weight: .semibold))
    }

    func textViewDidChange(_ textView: UITextView) {
        let enablet = textView.text?.isEmpty ?? true
        setSendBtn(enablet: enablet)
        
        if enablet {
            setTextView(textView: textView, text: "Write here...", font: UIFont.systemFont(ofSize: 22, weight: .light))
        }
        else {
            setTextView(textView: textView, text: textView.text, font: UIFont.systemFont(ofSize: 22, weight: .semibold))
        }
    }
}


class Gratitude: Codable {
    var title: String?
    var date: Date?
    
    private static let storageKey = "savedGratitudes"
    
    static func loadAll() -> [Gratitude] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Gratitude].self, from: data)) ?? []
    }
    
    static func add(_ gratitude: Gratitude) {
        var gratitudes = loadAll()
        gratitudes.append(gratitude)
        saveAll(gratitudes)
    }
    
    private static func saveAll(_ gratitudes: [Gratitude]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(gratitudes) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}

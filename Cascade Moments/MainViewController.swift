
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var widthStone: NSLayoutConstraint!
    @IBOutlet weak var topStone: NSLayoutConstraint!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var stoneImgView: UIImageView!
    @IBOutlet weak var throwBtn: UIButton!
    
    @IBOutlet weak var startDescrView: UIView!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resTitle: UILabel!
    @IBOutlet weak var stepImgView: UIImageView!
    @IBOutlet weak var mainResultView: UIView!
    @IBOutlet weak var descrImgView: UIImageView!
    @IBOutlet weak var resDescrLabel: UILabel!
    @IBOutlet weak var resBtnsView: UIView!
    @IBOutlet weak var flagBtn: UIButton!
    
    @IBOutlet weak var resStartBtn: UIButton!
    
    @IBOutlet weak var waitTimeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dailyBtn: UIButton!
    @IBOutlet weak var meditationBtn: UIButton!
    
    
    let screenHeight = UIScreen.main.bounds.height
    var calculatedHeight: CGFloat = 0.0
    
    private  var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    deinit {
        timer = nil
    }
    var time = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatedHeight = screenHeight / 812
        widthStone.constant = 124 * calculatedHeight
        topStone.constant = 116 / calculatedHeight
        
        mainResultView.layer.borderColor = UIColor.white.cgColor
        mainResultView.layer.borderWidth = 1
        
        restartScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if time == 0 {
            restartScreen()
        }
    }
    
    func rotateImageView() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotationAnimation.duration = 5
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isCumulative = true

        stoneImgView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopRotation() {
        stoneImgView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    private func animationStoneFall() {
        startDescrView.isHidden = true
        UIView.animate(withDuration: 0.4, animations: {
            self.topStone.constant = 166 * self.calculatedHeight
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.rotateImageView()
            self.animationStoneGo()
            self.recordAnimation = true
            self.animationStoneLeftRight()
        })
    }

    private var recordAnimation = true
    private var defaltShift = true
    
    private func animationStoneLeftRight() {
        guard recordAnimation else { return }

        let shift: CGFloat = self.defaltShift ? -30 : 30
        UIView.animate(withDuration: 1, animations: {
            self.centerConstraint.constant = shift
            self.view.layoutIfNeeded()
            self.defaltShift = !self.defaltShift
        }, completion: { _ in
            self.animationStoneLeftRight()
        })
    }
    
    func stopLeftRightdAnimation() {
        recordAnimation = false
        centerConstraint?.constant = 0
    }
    
    private func animationStoneGo() {
        UIView.animate(withDuration: 7, animations: {
            self.topStone.constant = 450 * self.calculatedHeight
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.stoneImgView.isHidden = true
            self.stopLeftRightdAnimation()
            self.resultView.isHidden = false
            self.stopRotation()
        })
    }

    private func restartScreen() {
        time = 300
        timeLabel.text = "05:00"
        stoneImgView.isHidden = false
        widthStone.constant = 124 * calculatedHeight
        topStone.constant = 116 / calculatedHeight
        startDescrView.isHidden = false
        resultView.isHidden = true
        dailyBtn.isHidden = true
        meditationBtn.isHidden = true
        throwBtn.isEnabled = true
        throwBtn.setTitle("Throw", for: .normal)
        resTitle.text = "Your Inspiration"
        descrImgView.isHidden = false
        descrImgView.image = UIImage(named: "resultDescr")
        resDescrLabel.isHidden = false
        resDescrLabel.text = "– Just as water gradually forms cascades, small efforts can lead to great results."
        resBtnsView.isHidden = false
        stepImgView.image = UIImage(named: "step1")
        
        let img = ShowInspiration.show ?? false ? UIImage(named: "resultFlagBtnOn") : UIImage(named: "resultFlagBtn")
        flagBtn.setImage(img, for: .normal)
    }
    
    
    @IBAction func tapThrow(_ sender: UIButton) {
        sender.setTitle("Throwing...", for: .normal)
        sender.isEnabled = false
        animationStoneFall()
    }
    
    @IBAction func tapResNext(_ sender: UIButton) {
        resBtnsView.isHidden = true
        resStartBtn.isHidden = false
        stepImgView.image = UIImage(named: "step2")
        descrImgView.image = UIImage(named: "5min")
        resDescrLabel.text = "Take 5 minutes to reflect on one small victory today."
    }
    
    var setFlag = false
    @IBAction func tapResFlag(_ sender: UIButton) {
        setFlag = !setFlag
        let img = setFlag ? UIImage(named: "resultFlagBtnOn") : UIImage(named: "resultFlagBtn")
        sender.setImage(img, for: .normal)
        ShowInspiration.show = setFlag
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    @objc func onTimerFires(){
        time -= 1
        let min: Int = time / 60
        let sec: Int = time - min * 60
        let secStr = sec < 10 ? "0" + String(sec) : String(sec)
        
        let timeStr = "0" + String(min) + ":" + secStr
        timeLabel.text = timeStr
        
        if time == 0 {
            timer?.invalidate()
            timer = nil
            setLastresView()
        }
    }
    
    private func setLastresView() {
        resTitle.text = "You have received a daily dose of positive mood!"
        dailyBtn.isHidden = false
        meditationBtn.isHidden = false
        descrImgView.isHidden = true
        resDescrLabel.isHidden = true
        waitTimeView.isHidden = true
    }
    
    @IBAction func tapResShare(_ sender: UIButton) {
        let resultStr = "– Just as water gradually forms cascades, small efforts can lead to great results."
        let vc = UIActivityViewController(activityItems: [resultStr], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapStart(_ sender: UIButton) {
        resStartBtn.isHidden = true
        waitTimeView.isHidden = false
        startTimer()
    }
    
    @IBAction func tapDaily(_ sender: UIButton) {
        restartScreen()
        customTabBarController?.currentVC = customTabBarController?.heardVC
    }
    
    @IBAction func tapMeditation(_ sender: UIButton) {
        restartScreen()
        customTabBarController?.currentVC = customTabBarController?.yogaVC
    }
}

class ShowInspiration: Codable {
    static let showInspirationKey = "showInspiration"
    static var show: Bool? {
        get {
            return UserDefaults.standard.value(forKey: ShowInspiration.showInspirationKey) as? Bool
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: ShowInspiration.showInspirationKey)
            UserDefaults.standard.synchronize()
        }
    }
}

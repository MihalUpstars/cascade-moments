
import UIKit
import AVFoundation

class YogaViewController: UIViewController {
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet var progressViews: [UIView]!
    
    lazy var backgroundPlayer: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "crickets", withExtension: "wav") else { return nil }
        let audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        audioPlayer?.numberOfLoops = 14 // 5 мин
        return audioPlayer
    }()
    
    var play = false {
        didSet {
            let img = play ? UIImage(named: "pausedBtn") : UIImage(named: "playBtn")
            playBtn.setImage(img, for: .normal)
            if play {
                backgroundPlayer?.play()
                startTimer()
            }
            else {
                backgroundPlayer?.pause()
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    private  var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    deinit {
        timer = nil
    }
    
    var time = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerView.layer.borderColor = UIColor.white.cgColor
        timerView.layer.borderWidth = 1
        
        for prView in progressViews {
            prView.alpha = 0.5
        }
        
        _ = backgroundPlayer
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    @objc func onTimerFires(){
        time += 1
        let min: Int = time / 60
        let sec: Int = time - min * 60
        let secStr = sec < 10 ? "0" + String(sec) : String(sec)
        
        let timeStr = "0" + String(min) + ":" + secStr
        timerLabel.text = timeStr
        
        let index = time/10
        progressViews[index].alpha = 1
        
        if time == 300 {
            timer?.invalidate()
            timer = nil
            time = 0
            play = false
            backgroundPlayer?.stop()
            for prView in progressViews {
                prView.alpha = 0.5
            }
        }
    }
    
    @IBAction func tapRepeat(_ sender: UIButton) {
        for prView in progressViews {
            prView.alpha = 0.5
        }
        timerLabel.text = "00:00"
        timer?.invalidate()
        timer = nil
        time = 0
        play = true
        backgroundPlayer?.stop()
        backgroundPlayer?.play()
    }
    
    @IBAction func tapPlay(_ sender: UIButton) {
        play = !play
    }
    
    @IBAction func tapShared(_ sender: UIButton) {
        let resultStr = "Today, my relaxation lasted " + (timerLabel.text ?? "") + "."
        let vc = UIActivityViewController(activityItems: [resultStr], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
}

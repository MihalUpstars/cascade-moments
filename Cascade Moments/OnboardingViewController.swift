
import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var step = 0 {
        didSet {
            if step == 5 {
                ShowOnboarding.show = false
                if let screen = TabBarViewController.loadFromStoryboard(name: "Main") {
                    self.navigationController?.pushViewController(screen, animated: false)
                }
            }
            else {
                let titleBtn = step == 4 ? "Start" : "Next"
                nextBtn.setTitle(titleBtn, for: .normal)
             
                titleLabel.text = arrTitle[step]
                descrLabel.text = sub[step]
            }
        }
    }
    var arrTitle = ["Start Your Day with Inspiration", "Set Your Daily Task", "Practice Meditation", "Daily Gratitude", "Save Your Favorite Inspirations"]
    var sub = ["Every day brings a new opportunity for growth. Our Daily Inspirations will help you stay motivated and focused, one small step at a time.", "Small tasks lead to big results. Choose one simple action each day that brings you closer to your goals. Every step matters, like a cascade of progress.", "Find your flow. Take a few minutes each day to meditate with a timer. Let your mind unwind and flow, just like water over rocks.", "Gratitude is the key to a positive mindset. Reflect on three things you’re thankful for each day, creating a cascade of positivity in your life.", "Found something that resonates with you? Save it for later and revisit your moments of inspiration whenever you need a boost."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func tapNext(_ sender: UIButton) {
        step += 1
    }
}


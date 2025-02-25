import UIKit

extension UIViewController {
    var customTabBarController: TabBarViewController? {
        return parent as? TabBarViewController
    }
}

class TabBarViewController: UIViewController {
    
    var currentVC: UIViewController? {
        didSet {
            guard currentVC != oldValue else { return }
            if let oldVC = oldValue {
                oldVC.willMove(toParent: nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParent()
            }
            presentControllerInContainer(currentVC)
            updateButtons()
        }
    }
    
    func presentControllerInContainer(_ vc: UIViewController?) {
        guard let vc = vc, let contentView = vc.view else { return }
        containerView?.addSubview(contentView)
        containerView?.pinSubview(contentView, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                        
        addChild(vc)
        vc.willMove(toParent: self)
    }
    
    static let sbName = "Main"
    let infoVC = InfoViewController.loadFromStoryboard(name: TabBarViewController.sbName)
    let heardVC = HeardViewController.loadFromStoryboard(name: TabBarViewController.sbName)
    let mainVC = MainViewController.loadFromStoryboard(name: TabBarViewController.sbName)
    let yogaVC = YogaViewController.loadFromStoryboard(name: TabBarViewController.sbName)
    let flagVC = FlagViewController.loadFromStoryboard(name: TabBarViewController.sbName)
    
    @IBOutlet weak var heightTabBar: NSLayoutConstraint!
    @IBOutlet weak var backgroundImg: UIImageView?
    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var infoBtn: UIButton?
    @IBOutlet weak var heardBtn: UIButton?
    @IBOutlet weak var mainBtn: UIButton?
    @IBOutlet weak var yogaBtn: UIButton?
    @IBOutlet weak var flagBtn: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let screenScale = UIScreen.main.scale

        let screenHeightInInches = screenHeight / screenScale / 163
        let screenWidthInInches = screenWidth / screenScale / 163
        let screenDiagonal = sqrt(pow(screenHeightInInches, 2) + pow(screenWidthInInches, 2))

        if screenDiagonal < 5.4 {
            heightTabBar.constant = 100
        }
        
        tapMain()
    }
  
    func updateButtons() {
        let infoImgName = (currentVC == infoVC) ?  "infoOn" : "infoOff"
        infoBtn?.setImage(UIImage(named: infoImgName), for: .normal)
        
        let heardImgName = (currentVC == heardVC) ?  "headOn" : "headOff"
        heardBtn?.setImage(UIImage(named: heardImgName), for: .normal)
        
        let mainImgName = (currentVC == mainVC) ?  "mainOn" : "mainOff"
        mainBtn?.setImage(UIImage(named: mainImgName), for: .normal)
        
        let yogaImgName = (currentVC == yogaVC) ?  "yogaOn" : "yogaOff"
        yogaBtn?.setImage(UIImage(named: yogaImgName), for: .normal)
        
        let flagImgName = (currentVC == flagVC) ? "flagOn" : "flagOff"
        flagBtn?.setImage(UIImage(named: flagImgName), for: .normal)
    }

    
    @IBAction func tapInfo() {
        currentVC = infoVC
    }
   
    @IBAction func tapHeard() {
        currentVC = heardVC
    }
    
    @IBAction func tapMain() {
        currentVC = mainVC
    }
    
    @IBAction func tapYoga() {
        currentVC = yogaVC
    }
    
    @IBAction func tapFlag() {
        currentVC = flagVC
    }
}

import UIKit
import WebKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader()
        var randomNumber = Double.random(in: 2...4)
 
        DispatchQueue.main.asyncAfter(deadline: .now() + randomNumber) {
            self.webView.isHidden = true
            self.imgView.isHidden = false

            randomNumber = 3
            UIView.animate(withDuration: randomNumber, animations: {
                self.imgView.alpha = 0
            }, completion: { _ in
                self.imgView.image = UIImage(named: "logo")
                self.imgView.alpha = 1

                UIView.animate(withDuration: randomNumber, animations: {
                    self.imgView.alpha = 0
                }, completion: { _ in
                    if ShowOnboarding.show ?? true {
                        if let screen = OnboardingViewController.loadFromStoryboard(name: "Main") {
                            self.navigationController?.pushViewController(screen, animated: false)
                        }
                    }
                    else {
                        if let screen = TabBarViewController.loadFromStoryboard(name: "Main") {
                            self.navigationController?.pushViewController(screen, animated: false)
                        }
                    }
                })
            })
        }
    }

    func showLoader() {
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.isHidden = false
        if let htmlURL = Bundle.main.url(forResource: "loader", withExtension: "html") {
            webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
        }
    }
}

class ShowOnboarding: Codable {
    static let showKey = "show"
    static var show: Bool? {
        get {
            return UserDefaults.standard.value(forKey: ShowOnboarding.showKey) as? Bool
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: ShowOnboarding.showKey)
            UserDefaults.standard.synchronize()
        }
    }
}

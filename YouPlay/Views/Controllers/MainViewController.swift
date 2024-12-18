import Foundation
import UIKit
import SnapKit
import LNPopupController
import RxSwift
import RxCocoa

protocol MainViewProtocol {
    init(playerViewController: MusicPlayerViewProtocol)
    var viewModel: MainViewModelProtocol? { get set }
}

class MainViewController: UITabBarController, MainViewProtocol, MainViewModelDelegate {
    
    private let playerViewController: MusicPlayerViewProtocol
    
    private var firstTimePopup = true
    
    required init(playerViewController: MusicPlayerViewProtocol) {
        self.playerViewController = playerViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var viewModel: MainViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private lazy var blur = UIBlurEffect(style: .dark)
    
    private lazy var blurView = UIVisualEffectView(effect: blur)
    
    override func viewDidLoad() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundEffect = blur
        tabBarAppearance.shadowImage = nil
        tabBarAppearance.shadowColor = nil
        tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        navigationController?.toolbar.isHidden = true
        super.viewDidLoad()
    }
    
    func onPlayerFileAppeared(title: String?, author: String?) {
        let popupAppearance = LNPopupBarAppearance()
        popupAppearance.titleTextAttributes = [.font: UIFont.mediumSizeBoldFont, .foregroundColor: UIColor.white]
        popupAppearance.subtitleTextAttributes = [.font: UIFont.mediumSizeFont, .foregroundColor: UIColor.gray]
        
        popupBar.inheritsAppearanceFromDockingView = true
        popupBar.standardAppearance = popupAppearance
        
        popupBar.progressViewStyle = .top
        popupContentView.popupCloseButtonStyle = .round
        
        popupBar.barStyle = .default
        popupBar.progressView.tintColor = .white
        DispatchQueue.main.async {
            self.presentPopupBar(withContentViewController: self.playerViewController, openPopup: false, animated: true, completion: nil)
        }
        
        if firstTimePopup {
            let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
            let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
            swipeGestureRecognizerLeft.direction = .left
            swipeGestureRecognizerRight.direction = .right
            
            popupBar.gestureRecognizers?.append(swipeGestureRecognizerLeft)
            popupBar.gestureRecognizers?.append(swipeGestureRecognizerRight)
            firstTimePopup = false
        }

    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            viewModel?.onPopupLeftSwipe()
        }
        if sender.direction == .right {
            viewModel?.onPopupRightSwipe()
        }
    }

}

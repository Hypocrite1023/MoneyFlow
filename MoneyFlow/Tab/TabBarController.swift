//
//  TabBarController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    let screenWidth = UIScreen.main.bounds.width
    var lastSideMenuXPosition: CGFloat?
    var sideView: SideMenuView?
    
    let accountingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let home = UINavigationController(rootViewController: HomeViewController())
        home.tabBarItem = UITabBarItem(title: NSLocalizedString("Tab_HomeView_Title", comment: ""), image: UIImage(systemName: "house"), tag: 0)
        
        let transactionView = UINavigationController(rootViewController: TransactionViewController())
        transactionView.tabBarItem = UITabBarItem(title: NSLocalizedString("Tab_Transaction_Title", comment: ""), image: UIImage(systemName: "creditcard"), tag: 1)
        
        let placeholderVC2 = UIViewController()
        placeholderVC2.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
        placeholderVC2.tabBarItem.isEnabled = false
        
        let goalView = UINavigationController(rootViewController: GoalViewController())
        goalView.tabBarItem = UITabBarItem(title: NSLocalizedString("Tab_Goal_Title", comment: ""), image: UIImage(systemName: "flag.fill"), tag: 3)
        
        let analysisView = UINavigationController(rootViewController: AnalysisViewViewController())
        analysisView.tabBarItem = UITabBarItem(title: NSLocalizedString("Tab_Analysis_Title", comment: ""), image: UIImage(systemName: "chart.bar.fill"), tag: 4)
        viewControllers = [home, transactionView, placeholderVC2, goalView, analysisView]

        accountingButton.addTarget(self, action: #selector(handleAddButtonTapped), for: .touchUpInside)
        self.view.addSubview(accountingButton)
        accountingButton.layer.cornerRadius = (tabBar.bounds.height + 10) / 2
        accountingButton.clipsToBounds = true
        accountingButton.heightAnchor.constraint(equalToConstant: tabBar.bounds.height + 10).isActive = true
        accountingButton.widthAnchor.constraint(equalToConstant: tabBar.bounds.height + 10).isActive = true
        accountingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        accountingButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        animeAccountingButton()
        
        let swipeLeftGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(uiScreenEdgePanGestureRecognizerAction))
        swipeLeftGesture.edges = .right
        self.view.addGestureRecognizer(swipeLeftGesture)
        lastSideMenuXPosition = screenWidth
        
        let closeSideViewGesture = UITapGestureRecognizer(target: self, action: #selector(closeSideViewGestureAction))
        closeSideViewGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(closeSideViewGesture)
        
        self.sideView = SideMenuView(frame: CGRect(origin: CGPoint(x: self.view.bounds.width, y: 0), size: CGSize(width: Int(self.screenWidth / 2), height: Int(self.view.bounds.height))))
        self.sideView?.appSettingButton.addTarget(self, action: #selector(openSettingView), for: .touchUpInside)
    }
    
    @objc func openSettingView() {
        let settingViewController = UINavigationController(rootViewController: SettingViewController())
        self.present(settingViewController, animated: true, completion: nil)
    }
    
    @objc func closeSideViewGestureAction() {
        UIView.animate(withDuration: 0.3) {
            self.sideView?.layer.transform = CATransform3DIdentity
        }
    }
    
    @objc func uiScreenEdgePanGestureRecognizerAction(sender: UIScreenEdgePanGestureRecognizer) {
        // state.rawValue -> pan: 2, end: 3
        print(sender.location(in: self.view))
        switch sender.state {
        case .possible:
            print("possible")
        case .began:
            print("began")
        case .changed:
            print("changed")
        case .ended:
            print("ended")
        case .cancelled:
            print("cancelled")
        case .failed:
            print("failed")
        case .recognized:
            print("recognized")
        @unknown default:
            print("default")
        }
        if sender.state == .ended {
            if sender.location(in: self.view).x < screenWidth * 0.7 {
                UIView.animate(withDuration: 0.3) {
                    var transform = CATransform3DIdentity

                    // 設定透視效果，讓旋轉更真實
                    transform.m34 = -1.0 / 500.0

                    // **先往左移動**（假設要從左側旋轉）
                    transform = CATransform3DTranslate(transform, -self.view.bounds.width / 2, 0, 0)

                    // **再旋轉**
                    transform = CATransform3DRotate(transform, CGFloat.pi / 12, 0, 1, 0)

                    self.view.layer.transform = transform
                } completion: { _ in
                    
                    guard let sideView = self.sideView else { return }
                    
                    self.view.superview?.addSubview(sideView)
                    UIView.animate(withDuration: 0.3) {
                        var transform = CATransform3DIdentity

                        // 設定透視效果，讓旋轉更真實
                        transform.m34 = -1.0 / 500.0

                        // **先往左移動**（假設要從左側旋轉）
                        transform = CATransform3DTranslate(transform, -self.view.bounds.width / 2, 0, 0)

                        // **再旋轉**
                        transform = CATransform3DRotate(transform, -CGFloat.pi / 12, 0, 1, 0)

                        sideView.layer.transform = transform
                    } completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                            var transform = sideView.layer.transform
                            // **再旋轉**
                            transform = CATransform3DRotate(transform, CGFloat.pi / 12, 0, 1, 0)

                            sideView.layer.transform = transform
                            
                        } completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.view.transform = .identity
                                self.view.layer.transform = CATransform3DIdentity
                            }
                        }
                    }
                }
            }
                                                            
        }
    }
    
    
    @objc func handleAddButtonTapped() {
        let vc = AccountingPageViewController()
//        vc.view.backgroundColor = .white
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func animeAccountingButton() {
        UIView.animate(withDuration: 0.1) {
            self.accountingButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.accountingButton.transform = .identity
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.accountingButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                } completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        self.accountingButton.transform = .identity
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.animeAccountingButton()
                    }
                }
            }
        }
    }
}

//
//  TabBarController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/21.
//

import UIKit

class TabBarController: UITabBarController {
    
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
        home.tabBarItem = UITabBarItem(title: "總覽", image: UIImage(systemName: "house"), tag: 0)
        
        let transactionView = UINavigationController(rootViewController: TransactionViewController())
        transactionView.tabBarItem = UITabBarItem(title: "收入支出", image: UIImage(systemName: "creditcard"), tag: 1)
        
        let placeholderVC2 = UIViewController()
        placeholderVC2.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
        placeholderVC2.tabBarItem.isEnabled = false
        
        let goalView = UINavigationController(rootViewController: GoalViewController())
        goalView.tabBarItem = UITabBarItem(title: "目標", image: UIImage(systemName: "flag.fill"), tag: 3)
        
        let analysisView = UINavigationController(rootViewController: AnalysisViewViewController())
        analysisView.tabBarItem = UITabBarItem(title: "分析", image: UIImage(systemName: "chart.bar"), tag: 4)
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

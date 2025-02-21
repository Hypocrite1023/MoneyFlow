//
//  ViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/16.
//

import UIKit

class HomeViewController: UIViewController {
    
    var homeView: HomeView?
    
    override func loadView() {
        super.loadView()
        homeView = HomeView()
        
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        
//        let randomGenerateTransaction = RandomGenerateTransaction()
//        randomGenerateTransaction.createRandomTransactionRecord()
        (view as? HomeView)?.segementControl.addTarget(self, action: #selector(handleSegmentControlValueChanged), for: .valueChanged)
        (view as? HomeView)?.viewDetailButton.addTarget(self, action: #selector(jumpToDetailView), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleSegmentControlValueChanged(sender: (view as? HomeView)!.segementControl)
        print("appear")
    }
    
    // 0: day, 1: week, 2: month, 3: year
    @objc func handleSegmentControlValueChanged(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        (view as? HomeView)?.updateTotalSpentLabel(value: AppData.shared.expense(index: sender.selectedSegmentIndex) ?? 0)
        (view as? HomeView)?.updateTotalIncomeLabel(value: AppData.shared.income(index: sender.selectedSegmentIndex) ?? 0)
        (view as? HomeView)?.updateChart(chartType: sender.selectedSegmentIndex)
    }
    
    @objc func jumpToDetailView() {
        tabBarController?.selectedIndex = 1
    }

}


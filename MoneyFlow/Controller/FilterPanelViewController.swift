//
//  FilterPanelViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/15.
//

import UIKit

class FilterPanelViewController: UIViewController {
    
    weak var filterDataDelegate: TransactionFilterDataDelegate?
    
    
    override func loadView() {
        view = FilterPanelView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(fetchTransactionByDate), name: SingleSelectionButtonView.singleSelectionButtonStateChangeNotification, object: (view as? FilterPanelView)?.dateRangeSelector)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: SingleSelectionButtonView.singleSelectionButtonStateChangeNotification, object: (view as? FilterPanelView)?.dateRangeSelector)
    }
    
    @objc func fetchTransactionByDate() {
        let predicate: NSPredicate?
        filterDataDelegate?.filterTransactions(with: AppConfig.TransactionTimePredicate(rawValue: ((view as? FilterPanelView)?.dateRangeSelector.selected.first)!)!.bothPredicate!)
    }
    

}

protocol TransactionFilterDataDelegate: AnyObject {
    func filterTransactions(with predicate: NSPredicate)
}

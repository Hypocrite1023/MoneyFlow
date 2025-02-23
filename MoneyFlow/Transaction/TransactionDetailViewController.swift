//
//  TransactionDetailViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/14.
//

import UIKit

class TransactionDetailViewController: UIViewController {
    
    override func loadView() {
        view = TransactionDetailView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let transactionDetailView = view as? TransactionDetailView {
            DispatchQueue.main.async {
                transactionDetailView.updateTransactionStack(transactions: CoreDataManager.shared.fetchAllTransactions()?.sorted(by: { transaction1, transaction2 in
                    transaction1.date > transaction2.date
                }))
            }
            transactionDetailView.transactionFilterButton.addTarget(self, action: #selector(showFilterPanel), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @objc func showFilterPanel() {
        let filterPanelVC = FilterPanelViewController()
        filterPanelVC.filterDataDelegate = self
        filterPanelVC.view.backgroundColor = .systemBackground
        filterPanelVC.modalPresentationStyle = .pageSheet

        if let sheet = filterPanelVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
        }

        present(filterPanelVC, animated: true)
    }
}

extension TransactionDetailViewController: TransactionFilterDataDelegate {
    func filterTransactions(with predicate: NSPredicate) {
        DispatchQueue.main.async {
            (self.view as? TransactionDetailView)?.updateTransactionStack(transactions: CoreDataManager.shared.fetchTransaction(withPredicate: predicate))
        }
    }
    
    
}

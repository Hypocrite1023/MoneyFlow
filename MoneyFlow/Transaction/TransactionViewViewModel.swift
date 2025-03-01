//
//  TransactionDetailViewViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/25.
//

import Foundation

class TransactionViewViewModel {
    @Published var filterPanelViewModel: FilterPanelViewModel
    @Published var transactions: [Transaction]
    
    init(filterPanelViewModel: FilterPanelViewModel = FilterPanelViewModel()) {
        self.filterPanelViewModel = filterPanelViewModel
        self.transactions = CoreDataManager.shared.fetchTransaction(withPredicate: filterPanelViewModel.generateFilterPredicate())
    }
    
    func fetchTransactions() {
        self.transactions = CoreDataManager.shared.fetchTransaction(withPredicate: filterPanelViewModel.generateFilterPredicate())
    }
    
    enum TransactionSection: Hashable {
        case date(String)
    }
}



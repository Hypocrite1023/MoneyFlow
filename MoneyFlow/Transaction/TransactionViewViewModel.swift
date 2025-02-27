//
//  TransactionDetailViewViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/25.
//

import Foundation

class TransactionViewViewModel {
    @Published var filterPanelViewModel: FilterPanelViewModel
    
    init(filterPanelViewModel: FilterPanelViewModel = FilterPanelViewModel()) {
        self.filterPanelViewModel = filterPanelViewModel
    }
    
    enum TransactionSection: Hashable {
        case date(String)
    }
}



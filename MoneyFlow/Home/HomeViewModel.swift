//
//  HomeViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/23.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var expense: Double?
    @Published var income: Double?
    
    @Published var sevenUnitExpense: [Double]?
    @Published var sevenUnitIncome: [Double]?
    @Published var sevenUnitDates: [String]?
    
    @Published var selectedDateRange: Int = 0
    private var cancellable = Set<AnyCancellable>()
    init() {
        $selectedDateRange.sink { [weak self] index in
            if let timeRangePredicate = CoreDataPredicate.TransactionDateRange(rawValue: index)?.predicate {
                self?.expense = CoreDataManager.shared.fetchTransaction(withPredicate: NSCompoundPredicate(andPredicateWithSubpredicates: [timeRangePredicate, CoreDataPredicate.TransactionType.expense.predicate]))?.reduce(0) {$0 + $1.amount} ?? 0
                self?.income = CoreDataManager.shared.fetchTransaction(withPredicate: NSCompoundPredicate(andPredicateWithSubpredicates: [timeRangePredicate, CoreDataPredicate.TransactionType.income.predicate]))?.reduce(0) {$0 + $1.amount} ?? 0
            }
        }
        .store(in: &cancellable)
        
    }
}

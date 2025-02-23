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
            if let timeRangePredicate = DateRange(rawValue: index)?.predicate {
                self?.expense = CoreDataManager.shared.fetchTransaction(withPredicate: NSCompoundPredicate(andPredicateWithSubpredicates: [timeRangePredicate, AppConfig.TransactionTypePredicate.expense.predicate]))?.reduce(0) {$0 + $1.amount} ?? 0
                self?.income = CoreDataManager.shared.fetchTransaction(withPredicate: NSCompoundPredicate(andPredicateWithSubpredicates: [timeRangePredicate, AppConfig.TransactionTypePredicate.income.predicate]))?.reduce(0) {$0 + $1.amount} ?? 0
            }
        }
        .store(in: &cancellable)
        
    }
    
    enum DateRange: Int, CaseIterable {
        case today = 0
        case thisWeek = 1
        case thisMonth = 2
        case thisYear = 3
        
        var title: String {
            switch self {
            case .today:
                return "今天"
            case .thisWeek:
                return "這週"
            case .thisMonth:
                return "這個月"
            case .thisYear:
                return "今年"
            }
        }
        var predicate: NSPredicate {
            switch self {
            case .today:
                AppConfig.TransactionTimePredicate.today.bothPredicate!
            case .thisWeek:
                AppConfig.TransactionTimePredicate.week.bothPredicate!
            case .thisMonth:
                AppConfig.TransactionTimePredicate.month.bothPredicate!
            case .thisYear:
                AppConfig.TransactionTimePredicate.year.bothPredicate!
            }
        }
    }
    
    
}

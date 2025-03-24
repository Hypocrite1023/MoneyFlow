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
    
    var baseCurrencyCode: String = "TWD"
    var currencyRates: [String: [String: Double]] = [:]
    var bindings: Set<AnyCancellable> = []
//    private var cancellable = Set<AnyCancellable>()
    
//    init() {
//        $selectedDateRange
//            .dropFirst()
//            .sink { [weak self] index in
//            if let timeRangePredicate = CoreDataPredicate.TransactionDateRange(rawValue: index)?.predicate {
//                self?.expense = CoreDataManager.shared.fetchTransaction(withPredicate: NSCompoundPredicate(andPredicateWithSubpredicates: [timeRangePredicate, CoreDataPredicate.TransactionType.expense.predicate]))?.reduce(0) {$0 + $1.amount} ?? 0
//                self?.income = CoreDataManager.shared.fetchTransaction(withPredicate: NSCompoundPredicate(andPredicateWithSubpredicates: [timeRangePredicate, CoreDataPredicate.TransactionType.income.predicate]))?.reduce(0) {$0 + $1.amount} ?? 0
//            }
//        }
//        .store(in: &cancellable)
//        
//    }
    
    func checkCurrencyRatesIntergreity() -> [String] {
        var needUpdateSet: Set<String> = []
        if let timeRangePredicate = CoreDataPredicate.TransactionDateRange(rawValue: selectedDateRange)?.predicate {
            CoreDataManager.shared.fetchTransaction(withPredicate: (timeRangePredicate, CoreDataPredicate.CoreDataPredicateTransactionType.type(uuid: CoreDataInitializer.shared.transactionTypeUUID[1]).predicate, nil, nil, nil)).forEach { transaction in
                if transaction.currencyCode != baseCurrencyCode {
                    let year = Calendar.current.component(.year, from: transaction.date)
                    let month = Calendar.current.component(.month, from: transaction.date)
                    let day = Calendar.current.component(.day, from: transaction.date)
                    needUpdateSet.insert(String(format: "%02d-%02d-%02d", year, month, day))
                }
            }
            CoreDataManager.shared.fetchTransaction(withPredicate: (timeRangePredicate, CoreDataPredicate.CoreDataPredicateTransactionType.type(uuid: CoreDataInitializer.shared.transactionTypeUUID[0]).predicate, nil, nil, nil)).forEach { transaction in
                if transaction.currencyCode != baseCurrencyCode {
                    let year = Calendar.current.component(.year, from: transaction.date)
                    let month = Calendar.current.component(.month, from: transaction.date)
                    let day = Calendar.current.component(.day, from: transaction.date)
                    needUpdateSet.insert(String(format: "%02d-%02d-%02d", year, month, day))
                }
            }
        }
        print(needUpdateSet)
        return needUpdateSet.sorted()
    }
    
    func reloadExpenseAndIncomeData() {
        
        CurrencyApi.shared.fetchCurrenciesRate(base: baseCurrencyCode, dates: checkCurrencyRatesIntergreity())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    if let timeRangePredicate = CoreDataPredicate.TransactionDateRange(rawValue: self.selectedDateRange)?.predicate {
                        self.expense = CoreDataManager.shared.fetchTransaction(withPredicate: (timeRangePredicate, CoreDataPredicate.CoreDataPredicateTransactionType.type(uuid: CoreDataInitializer.shared.transactionTypeUUID[1]).predicate, nil, nil, nil)).reduce(0) {
                            if $1.currencyCode != self.baseCurrencyCode {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                if let rate = CurrencyRateCacheManager.shared.getCurrencyRatePair(forDate: dateFormatter.string(from: $1.date)) {
                                    if let tmp = rate.rates[$1.currencyCode] ?? 1 {
                                        return $0 + $1.amount / tmp
                                    }
                                }
                            }
                            return $0 + $1.amount
                        }
                        
                        self.income = CoreDataManager.shared.fetchTransaction(withPredicate: (timeRangePredicate, CoreDataPredicate.CoreDataPredicateTransactionType.type(uuid: CoreDataInitializer.shared.transactionTypeUUID[0]).predicate, nil, nil, nil)).reduce(0) {
                            if $1.currencyCode != self.baseCurrencyCode {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                if let rate = CurrencyRateCacheManager.shared.getCurrencyRatePair(forDate: dateFormatter.string(from: $1.date)) {
                                    if let tmp = rate.rates[$1.currencyCode] ?? 1 {
                                        return $0 + $1.amount / tmp
                                    }
                                }
                            }
                            return $0 + $1.amount
                        }
                    }
                }
            } receiveValue: { rates in
//                print(rates)
            }
            .store(in: &bindings)

//        if let timeRangePredicate = CoreDataPredicate.TransactionDateRange(rawValue: selectedDateRange)?.predicate {
//            expense = CoreDataManager.shared.fetchTransaction(withPredicate: (timeRangePredicate, CoreDataPredicate.CoreDataPredicateTransactionType.type(uuid: CoreDataInitializer.shared.transactionTypeUUID[1]).predicate, nil, nil, nil)).reduce(0) {
//                
//                return $0 + $1.amount
//            }
//            
//            income = CoreDataManager.shared.fetchTransaction(withPredicate: (timeRangePredicate, CoreDataPredicate.CoreDataPredicateTransactionType.type(uuid: CoreDataInitializer.shared.transactionTypeUUID[0]).predicate, nil, nil, nil)).reduce(0) {
//                if $1.currencyCode != baseCurrencyCode {
//                    print($1.currencyCode)
//                }
//                return $0 + $1.amount
//            }
//        }
    }
    
    func reloadTransactionData() {
        sevenUnitExpense = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: AppDateGenerater.DateUnit(rawValue: selectedDateRange)!).map{ (_, startDate, endDate) in
            return CoreDataManager.shared.fetchTransactionWith(withSpecifyDateRange: (startDate, endDate), type: .type(uuid: CoreDataInitializer.shared.transactionTypeUUID[1]))?.reduce(0) { $0 + $1.amount } ?? 0
        }
        sevenUnitIncome = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: AppDateGenerater.DateUnit(rawValue: selectedDateRange)!).map{ (_, startDate, endDate) in
            return CoreDataManager.shared.fetchTransactionWith(withSpecifyDateRange: (startDate, endDate), type: .type(uuid: CoreDataInitializer.shared.transactionTypeUUID[0]))?.reduce(0) { $0 + $1.amount } ?? 0
        }
        sevenUnitDates = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: AppDateGenerater.DateUnit(rawValue: selectedDateRange)!).map{ (dateString, _, _) in
            return dateString
        }
    }
}

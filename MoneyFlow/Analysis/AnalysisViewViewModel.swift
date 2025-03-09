//
//  AnalysisViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/6.
//

import Foundation
import Combine
import DGCharts

class AnalysisViewViewModel {
    @Published var yearSelectionList: [Int] = Array(2020...Calendar.current.component(.year, from: Date()))
    
    @Published var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    var bindings: Set<AnyCancellable> = []
    
    @Published var lhsTransactions: [Transaction] = []
    @Published var rhsTransactions: [Transaction] = [] {
        didSet {
            expensePieChartData = []
            calculateTransactionInfo()
        }
    }
    @Published var rhsExpense: Double = 0
    @Published var rhsIncome: Double = 0
    @Published var rhsBalance: Double = 0
    
    @Published var lhsExpense: Double = 0
    @Published var lhsIncome: Double = 0
    @Published var lhsBalance: Double = 0
    
    @Published var commonUsedPaymentMethodString: String?
    @Published var commonUsedTagString: String?
    @Published var expensePieChartData: [PieChartDataEntry] = []
    @Published var expenseGroupByCategoryDict: [String: Double] = [:]
    
    init() {
        setBindings()
        fetchTransactions()
    }
    
    private func setBindings() {
        $selectedYear
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchTransactions()
            }
            .store(in: &bindings)
        
        $selectedMonth
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchTransactions()
            }
            .store(in: &bindings)
    }
    
    private func fetchTransactions() {
//        print("fetch Transacitons \(selectedYear) \(selectedMonth)")
        let (lyear, lmonth) = monthBeforeThisMonth(year: selectedYear, month: selectedMonth)
        lhsTransactions = CoreDataManager.shared.fetchTransactionByYearMonth(year: lyear, month: lmonth)
        rhsTransactions = CoreDataManager.shared.fetchTransactionByYearMonth(year: selectedYear, month: selectedMonth)
        
        
//        print(rhsTransactions)
    }
    
    func monthBeforeThisMonth(year: Int, month: Int) -> (year: Int, month: Int) {
        guard month > 1 else {
            return (year: year - 1, month: 12)
        }
        return (year: year, month: month - 1)
    }
    
    private func calculateTransactionInfo() {
        rhsExpense = rhsTransactions.reduce(0) {
            return $1.type == "支出" ? $0 + $1.amount : $0
        }
        rhsIncome = rhsTransactions.reduce(0) {
            return $1.type == "收入" ? $0 + $1.amount : $0
        }
        rhsBalance = rhsIncome - rhsExpense
        
        lhsExpense = lhsTransactions.reduce(0) {
            return $1.type == "支出" ? $0 + $1.amount : $0
        }
        lhsIncome = lhsTransactions.reduce(0) {
            return $1.type == "收入" ? $0 + $1.amount : $0
        }
        lhsBalance = lhsIncome - lhsExpense
        
        var commonUsedPaymentMethod: [String: Int] = [:]
        var commonUsedTag: [String: Int] = [:]
        var expenseByCategory: [String: Double] = [:]
        rhsTransactions.forEach { transaction in
            if !commonUsedPaymentMethod.keys.contains(transaction.payMethod) {
                commonUsedPaymentMethod.updateValue(1, forKey: transaction.payMethod)
            } else {
                commonUsedPaymentMethod.updateValue(commonUsedPaymentMethod[transaction.payMethod]! + 1, forKey: transaction.payMethod)
            }
            if let tags = transaction.tags {
                for tag in tags {
                    if !commonUsedTag.keys.contains(tag) {
                        commonUsedTag.updateValue(1, forKey: tag)
                    } else {
                        commonUsedTag.updateValue(commonUsedTag[tag]! + 1, forKey: tag)
                    }
                }
            }
            if transaction.type == "支出" {
                if !expenseByCategory.keys.contains(transaction.category) {
                    expenseByCategory.updateValue(transaction.amount, forKey: transaction.category)
                } else {
                    expenseByCategory.updateValue(expenseByCategory[transaction.category]! + transaction.amount, forKey: transaction.category)
                }
            }
            
        }
        let topThreePaymentMethod = commonUsedPaymentMethod.sorted(by: { $0.value > $1.value }).prefix(3).map(\.key)
        let topThreeTag = commonUsedTag.sorted(by: { $0.value > $1.value }).prefix(3).map(\.key)
        commonUsedPaymentMethodString = topThreePaymentMethod.joined(separator: "、")
        commonUsedTagString = topThreeTag.joined(separator: "、")
        for key in expenseByCategory.keys {
            expensePieChartData.append(PieChartDataEntry(value: expenseByCategory[key]! / rhsExpense * 100, label: key))
        }
        expensePieChartData.sort { $0.value > $1.value }
        expenseGroupByCategoryDict = expenseByCategory
    }
}

//
//  AppData.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/15.
//

import Foundation

class AppData {
    static let shared = AppData()
    private init() {}
    
    var dailyCosts: Double? {
        get {
            if let timePredicate = AppConfig.TransactionTimePredicate.today.bothPredicate {
                let typePredicate = AppConfig.TransactionTypePredicate.expense.predicate
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, typePredicate])
                let transactions = CoreDataManager.shared.fetchTransaction(withPredicate: predicate)
                guard let transactions else { print("transaction error"); return nil }
                return transactions.reduce(0) { $0 + $1.amount }
            } else {
                print("transaction error")
                return nil
            }
        }
    }
    var weeklyCosts: Double? {
        get {
            if let timePredicate = AppConfig.TransactionTimePredicate.week.bothPredicate {
                let typePredicate = AppConfig.TransactionTypePredicate.expense.predicate
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, typePredicate])
                let transactions = CoreDataManager.shared.fetchTransaction(withPredicate: predicate)
                guard let transactions else { print("transaction error"); return nil }
                return transactions.reduce(0) { $0 + $1.amount }
            } else {
                print("transaction error")
                return nil
            }
        }
    }
    var monthlyCosts: Double? {
        get {
            if let timePredicate = AppConfig.TransactionTimePredicate.month.bothPredicate {
                let typePredicate = AppConfig.TransactionTypePredicate.expense.predicate
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, typePredicate])
                let transactions = CoreDataManager.shared.fetchTransaction(withPredicate: predicate)
                guard let transactions else { print("transaction error"); return nil }
                return transactions.reduce(0) { $0 + $1.amount }
            } else {
                print("transaction error")
                return nil
            }
        }
    }
    var yearlyCosts: Double? {
        get {
            if let timePredicate = AppConfig.TransactionTimePredicate.year.bothPredicate {
                let typePredicate = AppConfig.TransactionTypePredicate.expense.predicate
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, typePredicate])
                let transactions = CoreDataManager.shared.fetchTransaction(withPredicate: predicate)
                guard let transactions else { print("transaction error"); return nil }
                return transactions.reduce(0) { $0 + $1.amount }
            } else {
                print("transaction error")
                return nil
            }
        }
    }
    
    var dailyIncome: Double? {
        get {
            if let timePredicate = AppConfig.TransactionTimePredicate.today.bothPredicate {
                let typePredicate = AppConfig.TransactionTypePredicate.income.predicate
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, typePredicate])
                let transactions = CoreDataManager.shared.fetchTransaction(withPredicate: predicate)
                guard let transactions else { print("transaction error"); return nil }
                return transactions.reduce(0) { $0 + $1.amount }
            } else {
                print("transaction error")
                return nil
            }
        }
    }
    var weeklyIncome: Double? {
        get {
            if let timePredicate = AppConfig.TransactionTimePredicate.week.bothPredicate {
                let typePredicate = AppConfig.TransactionTypePredicate.income.predicate
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, typePredicate])
                let transactions = CoreDataManager.shared.fetchTransaction(withPredicate: predicate)
                guard let transactions else { print("transaction error"); return nil }
                return transactions.reduce(0) { $0 + $1.amount }
            } else {
                print("transaction error")
                return nil
            }
        }
    }
    var monthlyIncome: Double? {
        get {
            if let timePredicate = AppConfig.TransactionTimePredicate.month.bothPredicate {
                let typePredicate = AppConfig.TransactionTypePredicate.income.predicate
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, typePredicate])
                let transactions = CoreDataManager.shared.fetchTransaction(withPredicate: predicate)
                guard let transactions else { print("transaction error"); return nil }
                return transactions.reduce(0) { $0 + $1.amount }
            } else {
                print("transaction error")
                return nil
            }
        }
    }
    var yearlyIncome: Double? {
        get {
            if let timePredicate = AppConfig.TransactionTimePredicate.year.bothPredicate {
                let typePredicate = AppConfig.TransactionTypePredicate.income.predicate
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, typePredicate])
                let transactions = CoreDataManager.shared.fetchTransaction(withPredicate: predicate)
                guard let transactions else { print("transaction error"); return nil }
                return transactions.reduce(0) { $0 + $1.amount }
            } else {
                print("transaction error")
                return nil
            }
        }
    }
    
    func expense(index: Int) -> Double? {
        switch index {
            case 0: return self.dailyCosts
            case 1: return self.weeklyCosts
            case 2: return self.monthlyCosts
            case 3: return self.yearlyCosts
            default: return nil
        }
    }
    func income(index: Int) -> Double? {
        switch index {
            case 0: return self.dailyIncome
            case 1: return self.weeklyIncome
            case 2: return self.monthlyIncome
            case 3: return self.yearlyIncome
            default: return nil
        }
    }
}

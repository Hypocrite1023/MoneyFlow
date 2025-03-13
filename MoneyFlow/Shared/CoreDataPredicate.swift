//
//  CoreDataPredicate.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/25.
//

import Foundation
import CoreData

enum CoreDataPredicate {
    enum TransactionTimePredicate: String, CaseIterable {
        case today = "今日", week = "本週", month = "本月", year = "今年"
        
        var bothPredicate: NSPredicate? {
            switch self {
                
            case .today:
                let startDate = Calendar.current.startOfDay(for: Date.now)
                
                let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
                guard let endDate else { return nil }

                return NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
            case .week:
                let interval = Calendar.current.dateInterval(of: .weekOfYear, for: .now)
                guard let interval else { return nil }
                return NSPredicate(format: "date >= %@ AND date <= %@", interval.start as NSDate, interval.end as NSDate)
            case .month:
                let interval = Calendar.current.dateInterval(of: .month, for: .now)
                guard let interval else { return nil }
                return NSPredicate(format: "date >= %@ AND date <= %@", interval.start as NSDate, interval.end as NSDate)
            case .year:
                let interval = Calendar.current.dateInterval(of: .year, for: .now)
                guard let interval else { return nil }
                return NSPredicate(format: "date >= %@ AND date <= %@", interval.start as NSDate, interval.end as NSDate)
            }
        }
        
        var expensePredicate: NSPredicate? {
            
            var interval: DateInterval?
            switch self {
                
            case .today:
                interval = Calendar.current.dateInterval(of: .day, for: .now)
                
                
            case .week:
                interval = Calendar.current.dateInterval(of: .weekOfYear, for: .now)
                
            case .month:
                interval = Calendar.current.dateInterval(of: .month, for: .now)
                
            case .year:
                interval = Calendar.current.dateInterval(of: .year, for: .now)
                
            }
            guard let interval else { return nil}
            return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "date >= %@ AND date <= %@", interval.start as NSDate, interval.end as NSDate), CoreDataPredicate.CoreDataPredicateTransactionType.type(uuid: CoreDataInitializer.shared.transactionTypeUUID[1]).predicate])
        }
        var incomePredicate: NSPredicate? {
            var interval: DateInterval?
            switch self {
                
            case .today:
                interval = Calendar.current.dateInterval(of: .day, for: .now)
                
            case .week:
                interval = Calendar.current.dateInterval(of: .weekOfYear, for: .now)
                
            case .month:
                interval = Calendar.current.dateInterval(of: .month, for: .now)
                
            case .year:
                interval = Calendar.current.dateInterval(of: .year, for: .now)
                
            }
            guard let interval else { return nil}
            return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "date >= %@ AND date <= %@", interval.start as NSDate, interval.end as NSDate), CoreDataPredicate.CoreDataPredicateTransactionType.type(uuid: CoreDataInitializer.shared.transactionTypeUUID[1]).predicate])
        }
    }
    
    enum TransactionDateRange: Int, CaseIterable {
        case today = 0
        case thisWeek = 1
        case thisMonth = 2
        case thisYear = 3
        
        var localized: String {
            switch self {
            case .today:
                return NSLocalizedString("HomeView_SegementControl_Today", comment: "")
            case .thisWeek:
                return NSLocalizedString("HomeView_SegementControl_ThisWeek", comment: "")
            case .thisMonth:
                return NSLocalizedString("HomeView_SegementControl_ThisMonth", comment: "")
            case .thisYear:
                return NSLocalizedString("HomeView_SegementControl_ThisYear", comment: "")
            }
        }
        
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
                TransactionTimePredicate.today.bothPredicate!
            case .thisWeek:
                TransactionTimePredicate.week.bothPredicate!
            case .thisMonth:
                TransactionTimePredicate.month.bothPredicate!
            case .thisYear:
                TransactionTimePredicate.year.bothPredicate!
            }
        }
        
        var expensePredicate: NSPredicate {
            switch self {
            case .today:
                TransactionTimePredicate.today.expensePredicate!
            case .thisWeek:
                TransactionTimePredicate.week.expensePredicate!
            case .thisMonth:
                TransactionTimePredicate.month.expensePredicate!
            case .thisYear:
                TransactionTimePredicate.year.expensePredicate!
            }
        }
    }
    
    enum CoreDataPredicateTransactionType {
//        case expense = "支出", income = "收入"
        case type(uuid: UUID)
//        var title: String {
//            switch self {
//            case .income:
//                return "收入"
//            case .expense:
//                return "支出"
//            }
//        }
        
        var predicate: NSPredicate {
            switch self {
            case .type(uuid: let uuid):
                return NSPredicate(format: "uuid == %@", uuid as CVarArg)
            }
        }
    }
    
    enum TransactionCategory {
        case category(categoryUUID: UUID), type(categoryType: UUID)
        
        var predicate: NSPredicate {
            switch self {
            case .category(categoryUUID: let uuid):
                return NSPredicate(format: "uuid == %@", uuid as CVarArg)
            case .type(categoryType: let type):
                return NSPredicate(format: "type == %@", type as CVarArg)
            }
        }
    }
    
    enum TransactionPaymentMethod {
        case paymentMethod(paymentMethodUUID: UUID)
        
        var predicate: NSPredicate {
            switch self {
            case .paymentMethod(paymentMethodUUID: let uuid):
                return NSPredicate(format: "uuid == %@", uuid as CVarArg)
            }
        }
    }
    
    enum TransactionTag {
        case tag(tagUUID: UUID)
        
        var predicate: NSPredicate {
            switch self {
            case .tag(tagUUID: let uuid):
                return NSPredicate(format: "uuid == %@", uuid as CVarArg)
            }
        }
    }
}

//
//  CoreDataPredicate.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/25.
//

import Foundation
import CoreData

enum CoreDataPredicate {
    enum TransactionDateRange: Int, CaseIterable {
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
    
    enum TransactionType: Int, CaseIterable {
        case income = 0, expense = 1
        
        var title: String {
            switch self {
            case .income:
                return "收入"
            case .expense:
                return "支出"
            }
        }
        
        var predicate: NSPredicate {
            return NSPredicate(format: "type == %@", self.title)
        }
    }
    
    enum TransactionCategory {
        case category(categoryName: String)
        
        var predicate: NSPredicate {
            switch self {
            case .category(categoryName: let name):
                return NSPredicate(format: "category == %@", name)
            }
        }
    }
    
    enum TransactionPaymentMethod {
        case paymentMethod(paymentMethodName: String)
        
        var predicate: NSPredicate {
            switch self {
            case .paymentMethod(paymentMethodName: let name):
                return NSPredicate(format: "paymentMethod == %@", name)
            }
        }
    }
    
    enum TransactionTag {
        case tag(tagName: String)
        
        var predicate: NSPredicate {
            switch self {
            case .tag(tagName: let name):
                return NSPredicate(format: "name == %@", name)
            }
        }
    }
}

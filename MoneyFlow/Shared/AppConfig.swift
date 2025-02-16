//
//  AppConfig.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/23.
//

import Foundation
import UIKit

class AppConfig {
    static let accountingTagsUserDefaultsKey = "accountingTags"
    enum Font {
        case title, secondaryTitle
        
        var value: UIFont {
            switch self {
            case .title:
                return .systemFont(ofSize: 24, weight: .bold)
            case .secondaryTitle:
                return .systemFont(ofSize: 18, weight: .bold)
            }
        }
    }
    
    enum SideSpace {
        case standard
        
        var value: CGFloat {
            switch self {
            case .standard:
                return 10
            }
        }
    }
    
    enum ButtonColor {
        case selected, unselected
        
        var backgroundColor: UIColor {
            switch self {
                
            case .selected:
                    .black
            case .unselected:
                    .systemGray6
            }
        }
        
        var fontColor: UIColor {
            switch self {
                
            case .selected:
                    .white
            case .unselected:
                    .black
            }
        }
    }
    
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
            return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "date >= %@ AND date <= %@", interval.start as NSDate, interval.end as NSDate), TransactionTypePredicate.expense.predicate])
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
            return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "date >= %@ AND date <= %@", interval.start as NSDate, interval.end as NSDate), TransactionTypePredicate.income.predicate])
        }
    }
    
    enum TransactionTypePredicate: String {
        case income = "收入", expense = "支出"
        
        var predicate: NSPredicate {
            return NSPredicate(format: "type == %@", self.rawValue)
        }
    }

}

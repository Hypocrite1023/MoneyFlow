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
    enum UserDefaultKey: String {
        case dailyExpenseLimit = "DailyExpenseLimit"
        case weeklyExpenseLimit = "WeeklyExpenseLimit"
        case monthlyExpenseLimit = "MonthlyExpenseLimit"
    }
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
}

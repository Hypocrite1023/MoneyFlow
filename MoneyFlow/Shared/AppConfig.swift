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
    static var titleFontSize: CGFloat = UserDefaults.standard.string(forKey: "AppLanguage") ?? "English" == "English" ? 22 : 24
    static var contentFontSize: CGFloat = UserDefaults.standard.string(forKey: "AppLanguage") ?? "English" == "English" ? 16 : 18
    enum Font {
        case title, secondaryTitle, tertiaryTitle, quaternaryTitle
        case content, subContent
        
        var value: UIFont {
            switch self {
            case .title:
                return .systemFont(ofSize: titleFontSize, weight: .bold)
            case .secondaryTitle:
                return .systemFont(ofSize: titleFontSize - 2, weight: .bold)
            case .tertiaryTitle:
                return .systemFont(ofSize: titleFontSize - 4, weight: .bold)
            case .quaternaryTitle:
                return .systemFont(ofSize: titleFontSize - 6, weight: .bold)
            case .content:
                return .systemFont(ofSize: contentFontSize, weight: .regular)
            case .subContent:
                return .systemFont(ofSize: contentFontSize - 2, weight: .regular)
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

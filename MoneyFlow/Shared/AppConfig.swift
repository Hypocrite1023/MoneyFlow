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
    
    enum AccountingCategory {
        case Food, Transportation, Life, Shopping, Travel, Housing, Health, Medical, Vehicle, Education, Entertainment, Insurance, Communication, Others
        
        var stringValue: String {
            switch self {
            // 飲食, 交通, 生活, 購物, 旅行, 居住, 健康, 醫療, 車輛, 教育, 娛樂, 保險, 通訊, 其他
            case .Food:
                "飲食"
            case .Transportation:
                "交通"
            case .Life:
                "生活"
            case .Shopping:
                "購物"
            case .Travel:
                "旅行"
            case .Housing:
                "居住"
            case .Health:
                "健康"
            case .Medical:
                "醫療"
            case .Vehicle:
                "車輛"
            case .Education:
                "教育"
            case .Entertainment:
                "娛樂"
            case .Insurance:
                "保險"
            case .Communication:
                "通訊"
            case .Others:
                "其他"
            }
        }
    }
}

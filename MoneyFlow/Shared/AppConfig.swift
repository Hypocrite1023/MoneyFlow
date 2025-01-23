//
//  AppConfig.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/23.
//

import Foundation
import UIKit

enum AppConfig {
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
}

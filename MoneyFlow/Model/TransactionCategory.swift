//
//  TransactionCategory.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/21.
//

import Foundation

enum TransactionCategory {
    case dining, transport, entertainemnt, shopping, other
    
    var description: String {
        switch self {
        case .dining:
            return "飲食"
        case .transport:
            return "交通"
        case .entertainemnt:
            return "娛樂"
        case .shopping:
            return "購物"
        case .other:
            return "其他"
        }
    }
    
    var imageName: String {
        switch self {
        case .dining:
            return "fork.knife.circle"
        case .transport:
            return "bus.doubledecker"
        case .entertainemnt:
            return "gamecontroller"
        case .shopping:
            return "cart.fill"
        case .other:
            return "ellipsis.circle"
        }
    }
}

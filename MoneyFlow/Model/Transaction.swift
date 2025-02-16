//
//  Transaction.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/4.
//

import Foundation

class Transaction {
    var date: Date
    var type: String
    var itemName: String
    var amount: Double
    var category: String
    var payMethod: String
    var tags: [String]?
    var note: String?
    
    init(date: Date, type: String, itemName: String, amount: Double, category: String, payMethod: String, tags: [String]?, note: String?) {
        self.date = date
        self.type = type
        self.itemName = itemName
        self.amount = amount
        self.category = category
        self.payMethod = payMethod
        self.tags = tags
        self.note = note
    }
    
    
}



enum PayMethod: Int, CaseIterable {
    case cash = 0
    case creditCard = 1
    case bankTransfer = 2
    case mobilePayment = 3
}

enum AccountingTransactionCategory: String, CaseIterable {
    case dining = "飲食", transport = "交通", life = "生活", shopping = "購物", traval = "旅行", living = "居住", healthy = "健康", medical = "醫療", vehical = "車輛",  educate = "教育", entertainment = "娛樂", insurance = "保險", communicate = "通訊",  other = "其他"
    
    
    var imageName: String {
        switch self {
        case .dining:
            return "fork.knife.circle"
        case .transport:
            return "bus.doubledecker"
        case .entertainment:
            return "gamecontroller"
        case .shopping:
            return "cart.fill"
        case .other:
            return "ellipsis.circle"
        case .life:
            return "figure.2"
        case .traval:
            return "figure.hiking"
        case .living:
            return "house.fill"
        case .healthy:
            return "heart.fill"
        case .medical:
            return "pills.circle.fill"
        case .vehical:
            return "car"
        case .educate:
            return "books.vertical"
        case .insurance:
            return "filemenu.and.cursorarrow"
        case .communicate:
            return "network"
        }
    }
}

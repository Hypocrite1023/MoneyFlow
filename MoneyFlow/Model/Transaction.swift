//
//  Transaction.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/4.
//

import Foundation

class Transaction {
    var date: Date
    var type: TransactionType
    var itemName: String
    var amount: Double
    var category: TransactionCategory
    var payMethod: PayMethod
    var tags: [String]
    var note: String
    
    init(date: Date, type: TransactionType, itemName: String, amount: Double, category: TransactionCategory, payMethod: PayMethod, tags: [String], note: String) {
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

enum TransactionType: Int, CaseIterable {
    case income = 0
    case expense = 1
}

enum PayMethod: Int, CaseIterable {
    case cash = 0
    case creditCard = 1
    case bankTransfer = 2
    case mobilePayment = 3
}

enum TransactionCategory: Int, CaseIterable {
    case dining = 0, transport = 1, entertainemnt = 2, shopping = 3, other = 4
    
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

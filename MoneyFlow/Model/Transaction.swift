//
//  Transaction.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/4.
//

import Foundation
import CoreData

struct Transaction: Hashable {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
//        return lhs.date == rhs.date && lhs.type == rhs.type && lhs.itemName == rhs.itemName
//        && lhs.amount == rhs.amount && lhs.category == rhs.category && lhs.payMethod == rhs.payMethod && lhs.tags == rhs.tags && lhs.note == rhs.note && lhs.relationGoal == rhs.relationGoal
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(type)
        hasher.combine(itemName)
        hasher.combine(amount)
        hasher.combine(category)
        hasher.combine(payMethod)
        hasher.combine(tags?.sorted() ?? [])
        hasher.combine(note)
        hasher.combine(relationGoal)
    }
    var id: NSManagedObjectID?
    var date: Date
    var type: UUID
    var itemName: String
    var amount: Double
    var currencyCode: String
    var category: UUID
    var categorySystemImageName: String?
    var payMethod: UUID
    var tags: [UUID]?
    var note: String?
    var relationGoal: UUID?
    
    init(date: Date, type: UUID, itemName: String, amount: Double, currencyCode: String, category: UUID, categorySystemImageName: String? = nil, payMethod: UUID, tags: [UUID]?, note: String?, relationGoal: UUID?) {
        self.date = date
        self.type = type
        self.itemName = itemName
        self.amount = amount
        self.currencyCode = currencyCode
        self.category = category
        self.categorySystemImageName = categorySystemImageName
        self.payMethod = payMethod
        self.tags = tags
        self.note = note
        self.relationGoal = relationGoal
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

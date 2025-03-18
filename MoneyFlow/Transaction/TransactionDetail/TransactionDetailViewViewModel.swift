//
//  TransactionDetailViewViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/25.
//

import Foundation
import Combine

class TransactionDetailViewViewModel {
    let transaction: Transaction
    @Published var date: Date
    @Published var type: UUID
    @Published var itemName: String
    @Published var amount: String
    @Published var currencyCode: String
    @Published var category: UUID
    @Published var payMethod: UUID
    @Published var tags: [UUID]?
    @Published var note: String?
    @Published var relationGoal: UUID?
    
    @Published var isEditing: Bool = false
    
    init(transaction: Transaction) {
        self.transaction = transaction
        self.date = transaction.date
        self.type = transaction.type
        self.itemName = transaction.itemName
        self.amount = transaction.amount.description
        self.currencyCode = transaction.currencyCode
        self.category = transaction.category
        self.payMethod = transaction.payMethod
        self.tags = transaction.tags
        self.note = transaction.note
        self.relationGoal = transaction.relationGoal
    }
    
    func isTransactionModified() -> Bool {
        return !(date == transaction.date && type == transaction.type && itemName == transaction.itemName && amount == transaction.amount.description && category == transaction.category && payMethod == transaction.payMethod && tags == transaction.tags && note == transaction.note && relationGoal == transaction.relationGoal)
    }
    
    func resetTransaction() {
        date = transaction.date
        type = transaction.type
        itemName = transaction.itemName
        amount = transaction.amount.description
        category = transaction.category
        payMethod = transaction.payMethod
        tags = transaction.tags
        note = transaction.note
        relationGoal = transaction.relationGoal
    }
    
    func toggleEditing() {
        isEditing.toggle()
    }
}

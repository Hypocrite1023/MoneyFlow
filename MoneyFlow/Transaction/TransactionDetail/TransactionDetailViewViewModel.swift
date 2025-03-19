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
    
    @Published var currencies: [CurrencyInformation.Information]?
    var cancellable: AnyCancellable?
    
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
        
        cancellable = CurrencyApi.shared.fetchSupportedCurrencies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] value in
                let currencies: CurrencyInformation = value
                self?.currencies = currencies.response
            })
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func isTransactionModified() -> Bool {
        return !(date == transaction.date && type == transaction.type && itemName == transaction.itemName && amount == transaction.amount.description && currencyCode == transaction.currencyCode && category == transaction.category && payMethod == transaction.payMethod && tags == transaction.tags && note == transaction.note && relationGoal == transaction.relationGoal)
    }
    
    func modifyTransaction() -> Result<String?, CoreDataManager.AccountingError>? {
        if isTransactionModified() {
            var modifiedTransaction = Transaction(date: date, type: type, itemName: itemName, amount: Double(amount)!, currencyCode: currencyCode, category: category, payMethod: payMethod, tags: tags, note: note, relationGoal: relationGoal)
            modifiedTransaction.id = transaction.id!
            return CoreDataManager.shared.modifyTransaction(modifiedTransaction)
        }
        return nil
    }
    
    func resetTransaction() {
        date = transaction.date
        type = transaction.type
        itemName = transaction.itemName
        amount = transaction.amount.description
        currencyCode = transaction.currencyCode
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

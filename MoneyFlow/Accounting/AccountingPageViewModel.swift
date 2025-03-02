//
//  AccountingPageViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/23.
//

import Foundation
import Combine

class AccountingPageViewModel {
    var transactionDate: Date = .now
    var transactionType: Int = -1 // -1 代表未選擇
    var transactionName: String?
    var transactionAmount: String?
    var transactionCategory: String?
    var transactionPaymentMethod: String?
    var transactionTag: [String]?
    var transactionNote: String?
    var relationGoalID: UUID?
    lazy var goalList: [GoalItem] = CoreDataManager.shared.fetchInProcessGoal()
    
    
    func makeAccounting() -> Result<String?, CoreDataManager.AccountingError> {
        
        guard let type = getAccountingType(index: transactionType), let transactionName, let transactionAmount, let amount = Double(transactionAmount), let category = transactionCategory, let payMethod = transactionPaymentMethod, let tags = transactionTag, let notes = transactionNote else {
            return .failure(CoreDataManager.AccountingError.transactionError)
        }
        
        let transaction = Transaction(date: transactionDate, type: type, itemName: transactionName, amount: amount, category: category, payMethod: payMethod, tags: tags, note: notes, relationGoal: relationGoalID)
        return CoreDataManager.shared.addTransaction(transaction)
    }
    
    func getAccountingType(index: Int) -> String? {
        switch index {
            case 0:
                return "支出"
            case 1:
                return "收入"
            default:
                return nil
        }
    }
    
}

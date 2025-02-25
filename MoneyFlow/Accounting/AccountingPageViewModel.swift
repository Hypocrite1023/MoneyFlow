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
    lazy var goalList: [GoalItem]? = CoreDataManager.shared.fetchAllGoalsStatus()
    
    enum AccountingError: Error {
        case transactionNameEmpty
        case transactionAmountEmpty
        case transactionAmountInvalid
        case transactionAmountIsZero
        case transactionError
        case transactionTypeNotSelect
        case transactionCategoryNotSelect
        case transactionPaymentMethodNotSelect
        case someCheckingError
        
        var errorMessage: String {
            switch self {
                
            case .transactionNameEmpty:
                return "項目名稱不可為空"
            case .transactionAmountEmpty:
                return "金額不可為空"
            case .transactionAmountInvalid:
                return "輸入的金額格式不正確"
            case .transactionAmountIsZero:
                return "輸入的金額不可為零"
            case .transactionError:
                return "紀錄錯誤"
            case .transactionTypeNotSelect:
                return "請選擇交易類型"
            case .transactionCategoryNotSelect:
                return "請選擇交易類別"
            case .transactionPaymentMethodNotSelect:
                return "請選擇交易支付方式"
            case .someCheckingError:
                return "請檢查輸入內容"
            }
        }
    }
    
    func makeAccounting() -> Result<String?, AccountingError> {
        var result: Result<String?, AccountingError> = .success(nil)
        checking: for checkingResult in [transactionTypeChecking(), transactionNameChecking(), transactionAmountChecking(), transactionCategoryChecking(), transactionPaymentMethodChecking()] {
            print(checkingResult)
            switch checkingResult {
            case .success(_):
                continue
            case .failure(let error):
                result = .failure(error)
                break checking
            }
        }
        switch result {
            
            case .success(_):
                guard let type = getAccountingType(index: transactionType), let transactionName, let transactionAmount, let amount = Double(transactionAmount), let category = transactionCategory, let payMethod = transactionPaymentMethod, let tags = transactionTag, let notes = transactionNote else {
                    return .failure(AccountingError.transactionError)
                }
            let transaction = Transaction(date: transactionDate, type: type, itemName: transactionName, amount: amount, category: category, payMethod: payMethod, tags: tags, note: notes, relationGoal: relationGoalID)
                CoreDataManager.shared.addTransaction(transaction)
                return .success("Make Accounting Successfully")
            case .failure(let error):
                return .failure(error)
        }
        
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
    
    func transactionTypeChecking() -> Result<String?, AccountingError> {
        guard transactionType != -1 else {
            return .failure(.transactionTypeNotSelect)
        }
        return .success(nil)
    }
    
    func transactionNameChecking() -> Result<String?, AccountingError> {
        guard let transactionName = transactionName else {
            return .failure(AccountingError.transactionNameEmpty)
        }
        guard transactionName != "" else {
            return .failure(AccountingError.transactionNameEmpty)
        }
        return .success(nil)
    }
    
    func transactionAmountChecking() -> Result<String?, AccountingError> {
        guard let transactionAmount = transactionAmount else {
            return .failure(AccountingError.transactionAmountEmpty)
        }
        guard transactionAmount != "" else {
            return .failure(AccountingError.transactionAmountEmpty)
        }
        guard let amount = Double(transactionAmount) else {
            return .failure(AccountingError.transactionAmountInvalid)
        }
        guard amount != 0.0 else {
            return .failure(AccountingError.transactionAmountIsZero)
        }
        return .success(nil)
    }
    
    func transactionCategoryChecking() -> Result<String?, AccountingError> {
        guard transactionCategory != nil  else {
            return .failure(.transactionCategoryNotSelect)
        }
        return .success(nil)
    }
    
    func transactionPaymentMethodChecking() -> Result<String?, AccountingError> {
        guard transactionPaymentMethod != nil else {
            return .failure(.transactionPaymentMethodNotSelect)
        }
        return .success(nil)
    }
}

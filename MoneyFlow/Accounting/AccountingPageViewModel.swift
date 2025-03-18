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
    var transactionType: UUID?
    var transactionName: String?
    var transactionAmount: String?
    var transactionCategory: UUID?
    var transactionPaymentMethod: UUID?
    var transactionTag: [UUID]?
    var transactionNote: String?
    var relationGoalID: UUID?
    lazy var goalList: [GoalItem] = CoreDataManager.shared.fetchInProcessGoal()
    
    @Published var currencies: [CurrencyInformation.Information]?
    @Published var selectedCurrency: String = "TWD"
    
//    var currencyRate: CurrencyRate?
//    var currencyHistory: CurrencyRate?
    var errorMessage: String? {
        didSet {
            print(errorMessage)
        }
    }
    private var bindings: Set<AnyCancellable> = []
    
    init() {
        CurrencyApi.shared.fetchSupportedCurrencies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] value in
                let currencies: CurrencyInformation = value
                self?.currencies = currencies.response
            })
            .store(in: &bindings)
        
//        CurrencyApi.shared.fetchCurrenciesLatest(base: "TWD")
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                switch completion {
//                    
//                case .finished:
//                    break
//                case .failure(let error):
//                    self.errorMessage = error.localizedDescription
//                }
//            } receiveValue: { [weak self] value in
//                self?.currencyRate = value
//            }
//            .store(in: &bindings)

    }
    
    
    func makeAccounting() -> Result<String?, CoreDataManager.AccountingError> {
        
        guard let type = transactionType, let transactionName, let transactionAmount, let amount = Double(transactionAmount), let category = transactionCategory, let payMethod = transactionPaymentMethod, let tags = transactionTag, let notes = transactionNote else {
            return .failure(CoreDataManager.AccountingError.transactionError)
        }
        
        let transaction = Transaction(date: transactionDate, type: type, itemName: transactionName, amount: amount, currencyCode: selectedCurrency, category: category, payMethod: payMethod, tags: tags, note: notes, relationGoal: relationGoalID)
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
    
    func addTag(tag: String) {
        CoreDataManager.shared.addTransactionTag(tag)
    }
    
}

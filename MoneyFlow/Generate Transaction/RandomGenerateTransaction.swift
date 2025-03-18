//
//  RandomGenerateTransaction.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/15.
//

import Foundation
import Combine

class RandomGenerateTransaction {
    
    var currencies: [CurrencyInformation.Information] = [] {
        didSet {
            if !currencies.isEmpty {
                createRandomTransactionRecord()
            }
        }
    }
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = CurrencyApi.shared.fetchSupportedCurrencies()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { value in
                let currency: CurrencyInformation = value
                self.currencies = currency.response
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func randomDate() -> Date {
        let calendar = Calendar.current
        let now = Date.now
        let past = calendar.date(byAdding: .year, value: -5, to: now)!
//        let interval = calendar.dateInterval(of: .year, for: .now)!
        
        let randomTimeInterval = TimeInterval.random(in: past.timeIntervalSince1970...now.timeIntervalSince1970)
        return Date(timeIntervalSince1970: randomTimeInterval)
    }
    
    func randomType() -> UUID {
        return CoreDataManager.shared.fetchAllTransactionType().randomElement()!.uuid
    }
    
    func randomAmount() -> Double {
        return Double(Int.random(in: 10...10000))
    }
    
    func randomCategory(type: UUID) -> UUID {
        let categories: [UUID] = CoreDataManager.shared.fetchTransactionCategories(predicate: .type(categoryType: type)).map { $0.uuid }
        
        return (categories.randomElement())!
    }
    
    func randomCurrency() -> String {
        if Int.random(in: 1...10) != 10 {
            return "TWD"
        } else {
            return currencies.randomElement()?.shortCode ?? "TWD"
        }
    }

    func randomPaymentMethod() -> UUID {
        let paymentMethods = CoreDataManager.shared.fetchAllTransactionPaymentMethods().map { $0.uuid }
        return (paymentMethods.randomElement())!
    }
    
    func randomTag() -> [UUID]? {
        let tags = CoreDataManager.shared.fetchAllTransactionTags().map { $0.uuid }
        let numberOfTags = Int.random(in: 0...3) // 最多 3 個標籤
            
            // 將陣列隨機排序後，選取前 N 個
        return Array(tags.shuffled().prefix(numberOfTags))
    }
    
    func randomCombinedItemName() -> String {
        let verbs = ["購買", "支付", "訂閱", "儲值", "吃", "喝", "參加", "使用"]
        let nouns = ["早餐", "午餐", "晚餐", "咖啡", "零食", "電影票", "公車票", "衣服", "書籍", "房租", "水電費", "健身房", "保險", "醫療費用"]
        
        let verb = verbs.randomElement() ?? "花費"
        let noun = nouns.randomElement() ?? "其他"
        
        return verb + noun
    }
    
    func createRandomTransactionRecord() {
        CoreDataManager.shared.fetchAllTransactionType().forEach { type in
            print(NSLocalizedString(type.nsLocalizedStringIdentifier, comment: ""))
        }
        for _ in 0..<30000 {
            let type = randomType()
            let transaction = Transaction(date: randomDate(), type: type, itemName: randomCombinedItemName(), amount: randomAmount(), currencyCode: randomCurrency(), category: randomCategory(type: type), payMethod: randomPaymentMethod(), tags: randomTag(), note: "", relationGoal: nil)
            let result = CoreDataManager.shared.addTransaction(transaction)
            print(result)
        }
    }
}

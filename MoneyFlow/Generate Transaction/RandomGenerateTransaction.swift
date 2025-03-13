//
//  RandomGenerateTransaction.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/15.
//

import Foundation

class RandomGenerateTransaction {
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
        print(CoreDataManager.shared.fetchAllTransactionType().map(\.uuid))
        print(CoreDataInitializer.shared.transactionTypeUUID)
        for _ in 0..<3000 {
            let type = randomType()
            let transaction = Transaction(date: randomDate(), type: type, itemName: randomCombinedItemName(), amount: randomAmount(), category: randomCategory(type: type), payMethod: randomPaymentMethod(), tags: randomTag(), note: "", relationGoal: nil)
//            print(NSLocalizedString((CoreDataManager.shared.fetchTransactionCategories(predicate: .category(categoryUUID: transaction.category)).first?.name)!, comment: ""))
            CoreDataManager.shared.addTransaction(transaction)
        }
    }
}

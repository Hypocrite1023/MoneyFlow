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
        let past = calendar.date(byAdding: .year, value: -3, to: now)!
//        let interval = calendar.dateInterval(of: .year, for: .now)!
        
        let randomTimeInterval = TimeInterval.random(in: past.timeIntervalSince1970...now.timeIntervalSince1970)
        return Date(timeIntervalSince1970: randomTimeInterval)
    }
    
    func randomType() -> String {
        return ["支出", "收入"].randomElement()!
    }
    
    func randomAmount() -> Double {
        return Double(Int.random(in: 10...10000))
    }
    
    func randomCategory(type: String) -> String {
        var categories: [String] = []
        if type == "支出" {
            categories = CoreDataManager.shared.fetchTransactionCategories(predicate: .type(categoryType: .expense))
        } else {
            categories = CoreDataManager.shared.fetchTransactionCategories(predicate: .type(categoryType: .income))
        }
        
        return (categories.randomElement())!
    }

    func randomPaymentMethod() -> String {
        let paymentMethods = CoreDataManager.shared.fetchAllTransactionPaymentMethods()
        return (paymentMethods.randomElement())!
    }
    
    func randomTag() -> [String]? {
        let tags = CoreDataManager.shared.fetchAllTransactionTags()
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
        for _ in 0..<3000 {
            let type = randomType()
            let transaction = Transaction(date: randomDate(), type: type, itemName: randomCombinedItemName(), amount: randomAmount(), category: randomCategory(type: type), payMethod: randomPaymentMethod(), tags: randomTag(), note: "", relationGoal: nil)
            CoreDataManager.shared.addTransaction(transaction)
        }
    }
}

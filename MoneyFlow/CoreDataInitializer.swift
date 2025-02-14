//
//  CoreDataInitializer.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/14.
//

import Foundation
import UIKit
import CoreData

class CoreDataInitializer {
    static let shared: CoreDataInitializer = CoreDataInitializer()
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    
    func initializeData() {
        let transactionCategoryFetchRequest: NSFetchRequest<TransactionCategory> = TransactionCategory.fetchRequest()
        // 檢查 category 的資料有沒有存在
        if (try? context.count(for: transactionCategoryFetchRequest)) == 0 {
            let categories = ["飲食", "交通", "生活", "購物", "旅行", "居住", "健康", "醫療", "車輛", "教育", "娛樂", "保險", "通訊", "其他"]
            for category in categories {
                let newCategory = TransactionCategory(context: context)
                newCategory.category = category
                newCategory.uuid = UUID()
            }
            
        }
        
        // 檢查 payment method 的資料有沒有存在
        let paymentMethodFetchRequest: NSFetchRequest<TransactionPaymentMethod> = TransactionPaymentMethod.fetchRequest()
        if (try? context.count(for: paymentMethodFetchRequest)) == 0 {
            let paymentMethods = ["現金", "行動支付", "信用卡", "轉帳", "其他"]
            for paymentMethod in paymentMethods {
                let newPaymentMethod = TransactionPaymentMethod(context: context)
                newPaymentMethod.paymentMethod = paymentMethod
                newPaymentMethod.uuid = UUID()
            }
        }
        
        // 儲存資料
        do {
            try context.save()
        } catch {
            print("Failed to initialize core data's data: \(error)")
        }
    }
}

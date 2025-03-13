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
    var transactionTypeUUID: [UUID] = [] // 收入, 支出
    var transactionCategory: [UUID: String] = [:]
    var transactionPaymentMethod: [UUID: String] = [:]
    var transactionTag: [UUID: String] = [:]
    
    func initializeData() {
//        CoreDataManager.resetCoreDataStore()
        
        
        // 檢查 transaction type 的資料有沒有存在
        let transactionTypeFetchRequest: NSFetchRequest<TransactionType> = TransactionType.fetchRequest()
        if (try? context.count(for: transactionTypeFetchRequest)) == 0 {
            let transactionTypes: [String] = ["CoreData_TransactionType_Income_Title", "CoreData_TransactionType_Expense_Title"]
            for type in transactionTypes {
                let newTransactionType = TransactionType(context: context)
                newTransactionType.type = type
                newTransactionType.uuid = UUID()
                transactionTypeUUID.append(newTransactionType.uuid!)
            }
        } else {
            CoreDataManager.shared.fetchAllTransactionType().forEach { type in
                if type.nsLocalizedStringIdentifier == "CoreData_TransactionType_Income_Title" {
                    transactionTypeUUID.insert(type.uuid, at: 0)
                } else {
                    transactionTypeUUID.append(type.uuid)
                }
            }
        }
        
        let transactionCategoryFetchRequest: NSFetchRequest<TransactionCategory> = TransactionCategory.fetchRequest()
    
        // 檢查 category 的資料有沒有存在
        if (try? context.count(for: transactionCategoryFetchRequest)) == 0 {
            let expenseCategories = [
                "CoreData_TransactionCategory_Expense_FoodAndDining",
                "CoreData_TransactionCategory_Expense_Transportation",
                "CoreData_TransactionCategory_Expense_Lifestyle",
                "CoreData_TransactionCategory_Expense_Shopping",
                "CoreData_TransactionCategory_Expense_Travel",
                "CoreData_TransactionCategory_Expense_Housing",
                "CoreData_TransactionCategory_Expense_Health",
                "CoreData_TransactionCategory_Expense_Medical",
                "CoreData_TransactionCategory_Expense_Vehicles",
                "CoreData_TransactionCategory_Expense_Education",
                "CoreData_TransactionCategory_Expense_Entertainment",
                "CoreData_TransactionCategory_Expense_Insurance",
                "CoreData_TransactionCategory_Expense_Communication",
                "CoreData_TransactionCategory_Expense_Other"
            ]
            let expenseCategoryiesSystemImage = ["fork.knife.circle",
                                                 "bus.doubledecker",
                                                 "figure.2",
                                                 "cart.fill",
                                                 "figure.hiking",
                                                 "house.fill",
                                                 "heart.fill",
                                                 "pills.circle.fill",
                                                 "car",
                                                 "books.vertical",
                                                 "gamecontroller",
                                                 "filemenu.and.cursorarrow",
                                                 "network",
                                                 "ellipsis.circle",
            ]
            for (category, systemImage) in zip(expenseCategories, expenseCategoryiesSystemImage) {
                let newCategory = TransactionCategory(context: context)
                newCategory.type = transactionTypeUUID[1]
                newCategory.category = category
                newCategory.uuid = UUID()
                newCategory.systemImage = systemImage
                newCategory.deletable = false
                transactionCategory.updateValue(category, forKey: newCategory.uuid!)
            }
            
            let incomeCategories = [
                "CoreData_TransactionCategory_Income_Salary",
                "CoreData_TransactionCategory_Income_Bonus",
                "CoreData_TransactionCategory_Income_Allowance",
                "CoreData_TransactionCategory_Income_Investment",
                "CoreData_TransactionCategory_Income_SideIncome",
                "CoreData_TransactionCategory_Income_RedEnvelope",
                "CoreData_TransactionCategory_Income_Other"
            ]
            let incomeCategoryiesSystemImage: [String] = [
                "person.crop.circle",
                "dollarsign.ring",
                "wallet",
                "dollarsign.arrow.trianglehead.counterclockwise.rotate.90",
                "tablecells.badge.ellipsis",
                "gift",
                "ellipsis.circle",
            ]
            for (category, systemImage) in zip(incomeCategories, incomeCategoryiesSystemImage) {
                let newCategory = TransactionCategory(context: context)
                newCategory.type = transactionTypeUUID[0]
                newCategory.category = category
                newCategory.uuid = UUID()
                newCategory.systemImage = systemImage
                newCategory.deletable = false
                transactionCategory.updateValue(category, forKey: newCategory.uuid!)
            }
        } else {
            transactionTypeUUID.forEach { uuid in
                CoreDataManager.shared.fetchTransactionCategories(predicate: .type(categoryType: uuid)).forEach { category in
                    transactionCategory.updateValue(category.name, forKey: category.uuid)
                }
            }
            
        }
        
        // 檢查 payment method 的資料有沒有存在
        let paymentMethodFetchRequest: NSFetchRequest<TransactionPaymentMethod> = TransactionPaymentMethod.fetchRequest()
        if (try? context.count(for: paymentMethodFetchRequest)) == 0 {
            let paymentMethods = ["CoreData_TransactionPaymentMethod_Cash", "CoreData_TransactionPaymentMethod_MobilePayment", "CoreData_TransactionPaymentMethod_CreditCard", "CoreData_TransactionPaymentMethod_Transfer", "CoreData_TransactionPaymentMethod_Other"]
            for paymentMethod in paymentMethods {
                let newPaymentMethod = TransactionPaymentMethod(context: context)
                newPaymentMethod.paymentMethod = paymentMethod
                newPaymentMethod.uuid = UUID()
            }
        } else {
            CoreDataManager.shared.fetchAllTransactionPaymentMethods().forEach { paymentMethod in
                transactionPaymentMethod.updateValue(paymentMethod.paymentMethod, forKey: paymentMethod.uuid)
            }
        }
        
        let transactionTagFetchRequest: NSFetchRequest<TransactionTag> = TransactionTag.fetchRequest()
        if (try? context.count(for: transactionTagFetchRequest)) != 0 {
            CoreDataManager.shared.fetchAllTransactionTags().forEach { tag in
                transactionTag.updateValue(tag.tag, forKey: tag.uuid)
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

//
//  CoreDataManager.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/5.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    
    static let shared: CoreDataManager = CoreDataManager()
    static let addTagNotificationName = Notification.Name("addTagNotification")
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Model") // data model file name
        persistentContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    func save() {
        guard persistentContainer.viewContext.hasChanges else {
            return
        }
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("persistent container save error: \(error)")
        }
        
    }
    
    func insert(transaction: Transaction) {
        let transactionEntity = NSEntityDescription.entity(forEntityName: "Transaction", in: persistentContainer.viewContext)!
        let newTransaction = NSManagedObject(entity: transactionEntity, insertInto: persistentContainer.viewContext)
        newTransaction.setValue(transaction.date, forKey: "date")
        newTransaction.setValue(transaction.type, forKey: "type")
        newTransaction.setValue(transaction.amount, forKey: "amount")
        newTransaction.setValue(transaction.itemName, forKey: "itemName")
        newTransaction.setValue(transaction.note, forKey: "note")
       
        save()
    }
    
    func resetCoreDataStore() {
        let fileManager = FileManager.default
        let storeURL = persistentContainer.persistentStoreDescriptions.first?.url

        do {
            if let storeURL = storeURL {
                try fileManager.removeItem(at: storeURL)
                print("Removed old database")
            }
        } catch {
            print("Failed to remove old database: \(error)")
        }
    }
}

// MARK: - Transaction
extension CoreDataManager {
    func addTransaction(_ transaction: Transaction) {
        let context = persistentContainer.viewContext
        let newTransaction = TransactionEntity(context: context)
        newTransaction.date = transaction.date
        newTransaction.type = transaction.type
        newTransaction.itemName = transaction.itemName
        newTransaction.amount = transaction.amount
        newTransaction.note = transaction.note
        
        let categoryFetchRequest: NSFetchRequest<TransactionCategory> = TransactionCategory.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "category == %@", transaction.category)
        if let category = try? context.fetch(categoryFetchRequest).first {
            newTransaction.transactionCategory = category
        }
        
        let paymentMethodFetchRequest: NSFetchRequest<TransactionPaymentMethod> = TransactionPaymentMethod.fetchRequest()
        paymentMethodFetchRequest.predicate = NSPredicate(format: "paymentMethod == %@", transaction.payMethod)
        if let paymentMethod = try? context.fetch(paymentMethodFetchRequest).first {
            newTransaction.transactionPaymentMethod = paymentMethod
        }
        
        var transactionTagSet: Set<TransactionTag> = []
        for transactionTag in transaction.tags {
            let tagsFetchRequest: NSFetchRequest<TransactionTag> = TransactionTag.fetchRequest()
            tagsFetchRequest.predicate = NSPredicate(format: "name == %@", transactionTag)
            if let tag = try? context.fetch(tagsFetchRequest).first {
                transactionTagSet.insert(tag)
            }
        }
        newTransaction.transactionTag = transactionTagSet as NSSet
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
// MARK: - Transaction Category
extension CoreDataManager {
    func fetchAllTransactionCategories() -> [String]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionCategory> = TransactionCategory.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            return categories.compactMap({$0.category})
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
// MARK: - Transaction Payment Method
extension CoreDataManager {
    func fetchAllTransactionPaymentMethods() -> [String]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionPaymentMethod> = TransactionPaymentMethod.fetchRequest()
        
        do {
            let paymentMethods = try context.fetch(fetchRequest)
            return paymentMethods.compactMap({$0.paymentMethod})
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
// MARK: - Transaction Tags
extension CoreDataManager {
    func fetchAllTransactionTags() -> [String]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionTag> = TransactionTag.fetchRequest()
        
        do {
            let tags = try context.fetch(fetchRequest)
//            print(tags.compactMap({$0.name}), "tags")
            let result = tags.compactMap({$0.name})
            return result.count == 0 ? nil : result
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func addTransactionTag(_ tag: String) {
        let context = persistentContainer.viewContext
        let newTag = TransactionTag(context: context)
        newTag.name = tag
        newTag.uuid = UUID()
        
        do {
            try context.save()
            NotificationCenter.default.post(name: Self.addTagNotificationName, object: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}

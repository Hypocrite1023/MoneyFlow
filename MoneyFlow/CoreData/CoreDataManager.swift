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
        
        if let relationGoal = transaction.relationGoal {
            let goalFetchRequest: NSFetchRequest<GoalConfiguration> = GoalConfiguration.fetchRequest()
            goalFetchRequest.predicate = NSPredicate(format: "id == %@", relationGoal as CVarArg)
            if let goal = try? context.fetch(goalFetchRequest).first {
                newTransaction.goalRelation = goal
            }
        }
        
        var transactionTagSet: Set<TransactionTag> = []
        if let transactionTags = transaction.tags {
            for transactionTag in transactionTags {
                let tagsFetchRequest: NSFetchRequest<TransactionTag> = TransactionTag.fetchRequest()
                tagsFetchRequest.predicate = NSPredicate(format: "name == %@", transactionTag)
                if let tag = try? context.fetch(tagsFetchRequest).first {
                    transactionTagSet.insert(tag)
                }
            }
        }
        
        newTransaction.transactionTag = transactionTagSet as NSSet
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllTransactions() -> [Transaction]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        do {
            let transactionEntities = try context.fetch(fetchRequest)
            return transactionEntities.map({
                let tags = $0.transactionTag?.compactMap{ (tag) -> String? in
                    guard let tag = tag as? TransactionTag else { return nil }
                    return tag.name
                }
                let transaction = Transaction(date: $0.date!,
                                              type: $0.type!,
                                              itemName: $0.itemName!,
                                              amount: $0.amount,
                                              category: ($0.transactionCategory?.category)!,
                                              payMethod: ($0.transactionPaymentMethod?.paymentMethod)!,
                                              tags: tags,
                                              note: $0.note, relationGoal: nil)
                return transaction
            })
            
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func fetchTransaction(withPredicate: (transactionPredicate: NSPredicate?, categoryPredicate: NSPredicate?, paymentMethodPredicate: NSPredicate?, tagPredicate: NSPredicate?)) -> [Transaction] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        fetchRequest.predicate = withPredicate.transactionPredicate
        
        let categoryFetchRequest: NSFetchRequest<TransactionCategory> = TransactionCategory.fetchRequest()
        categoryFetchRequest.predicate = withPredicate.categoryPredicate
        guard let categories = try? context.fetch(categoryFetchRequest) else {
            return []
        }
        
        let paymentMethodFetchRequest: NSFetchRequest<TransactionPaymentMethod> = TransactionPaymentMethod.fetchRequest()
        paymentMethodFetchRequest.predicate = withPredicate.paymentMethodPredicate
        guard let paymentMethods = try? context.fetch(paymentMethodFetchRequest) else {
            return []
        }
        
        let tagsFetchRequest: NSFetchRequest<TransactionTag> = TransactionTag.fetchRequest()
        tagsFetchRequest.predicate = withPredicate.tagPredicate
        guard let tags = try? context.fetch(tagsFetchRequest) else {
            return []
        }
        
        do {
            let transactionEntities = try context.fetch(fetchRequest)
            return transactionEntities.compactMap({
                let set = Set(tags.compactMap{ $0.name })
                let set2 = $0.transactionTag?.compactMap { ($0 as? TransactionTag)?.name }
                guard let set2 else {
                    return nil
                }
                
                if !categories.contains($0.transactionCategory!) || !paymentMethods.contains($0.transactionPaymentMethod!) {
                    return nil
                }
                
                // 當 transactionTag's predicate is nil -> 代表沒選任何tag -> transaction 有tag 沒tag都要列出
                // 當 transactionTag's predicate is not nil -> 有篩選tag -> 列出的transaction 的 tag 要是 選擇的tag的子集合 -> 但是又不能列出 transaction 的 tag 是 nil 的
                print(Set(set), set2, !Set(set2).isSubset(of: set) || Set(set2).isEmpty, withPredicate.tagPredicate != nil)
                
                if (!Set(set2).isSubset(of: set) || Set(set2).isEmpty && withPredicate.tagPredicate != nil) {
                    return nil
                }
                
                
                let tags = $0.transactionTag?.compactMap{ (tag) -> String? in
                    guard let tag = tag as? TransactionTag else { return nil }
                    return tag.name
                }
                let transaction = Transaction(date: $0.date!,
                                              type: $0.type!,
                                              itemName: $0.itemName!,
                                              amount: $0.amount,
                                              category: ($0.transactionCategory?.category)!,
                                              payMethod: ($0.transactionPaymentMethod?.paymentMethod)!,
                                              tags: tags,
                                              note: $0.note, relationGoal: nil)
                return transaction
            })
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func fetchTransaction(withPredicate: NSPredicate) -> [Transaction]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        fetchRequest.predicate = withPredicate
        
        
        do {
            let transactionEntities = try context.fetch(fetchRequest)
            return transactionEntities.compactMap({
                let tags = $0.transactionTag?.compactMap{ (tag) -> String? in
                    guard let tag = tag as? TransactionTag else { return nil }
                    return tag.name
                }
                let transaction = Transaction(date: $0.date!,
                                              type: $0.type!,
                                              itemName: $0.itemName!,
                                              amount: $0.amount,
                                              category: ($0.transactionCategory?.category)!,
                                              payMethod: ($0.transactionPaymentMethod?.paymentMethod)!,
                                              tags: tags,
                                              note: $0.note, relationGoal: nil)
                return transaction
            })
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func fetchTransactionWith(withSpecifyDateRange: (start: Date, end: Date), type: CoreDataPredicate.TransactionType) -> [Transaction]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        let datePredicate = NSPredicate(format: "(date >= %@) AND (date < %@)", withSpecifyDateRange.start as NSDate, withSpecifyDateRange.end as NSDate)
        let typePredicate = type.predicate
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, typePredicate])
//        print(predicate)
        fetchRequest.predicate = predicate
        do {
            let transactionEntities = try context.fetch(fetchRequest)
            return transactionEntities.map({
                let tags = $0.transactionTag?.compactMap{ (tag) -> String? in
                    guard let tag = tag as? TransactionTag else { return nil }
                    return tag.name
                }
                let transaction = Transaction(date: $0.date!,
                                              type: $0.type!,
                                              itemName: $0.itemName!,
                                              amount: $0.amount,
                                              category: ($0.transactionCategory?.category)!,
                                              payMethod: ($0.transactionPaymentMethod?.paymentMethod)!,
                                              tags: tags,
                                              note: $0.note, relationGoal: nil)
                return transaction
            })
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
// MARK: - Transaction Category
extension CoreDataManager {
    func fetchAllTransactionCategories() -> [String] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionCategory> = TransactionCategory.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            return categories.compactMap({$0.category})
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}
// MARK: - Transaction Payment Method
extension CoreDataManager {
    func fetchAllTransactionPaymentMethods() -> [String] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionPaymentMethod> = TransactionPaymentMethod.fetchRequest()
        
        do {
            let paymentMethods = try context.fetch(fetchRequest)
            return paymentMethods.compactMap({$0.paymentMethod})
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}
// MARK: - Transaction Tags
extension CoreDataManager {
    func fetchAllTransactionTags() -> [String] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionTag> = TransactionTag.fetchRequest()
        
        do {
            let tags = try context.fetch(fetchRequest)
//            print(tags.compactMap({$0.name}), "tags")
            let result = tags.compactMap({$0.name})
            return result.count == 0 ? [] : result
        } catch {
            print(error.localizedDescription)
        }
        
        return []
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

// MARK: - Goal
extension CoreDataManager {
    func addGoal(_ name: String, amount: Double, startDate: Date, endDate: Date?) {
        let context = persistentContainer.viewContext
        let newGoal = GoalConfiguration(context: context)
        newGoal.id = UUID()
        newGoal.goalName = name
        newGoal.goalAmount = amount
        newGoal.goalStartDate = startDate
        newGoal.goalEndDate = endDate
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllGoalsStatus() -> [GoalItem]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<GoalConfiguration> = GoalConfiguration.fetchRequest()
        do {
            let goals = try context.fetch(fetchRequest)
            return goals.map {
                let predicate = NSPredicate(format: "goalRelation == %@", $0)
                if let transactions = fetchTransaction(withPredicate: predicate) {
                    let currentAmount = transactions.reduce(0) { $0 + $1.amount }
                    return GoalItem(id: $0.id!, name: $0.goalName, targetAmount: $0.goalAmount, currentAmount: currentAmount)
                } else {
                    return GoalItem(id: $0.id!, name: $0.goalName, targetAmount: $0.goalAmount, currentAmount: 0)
                }
                
                
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

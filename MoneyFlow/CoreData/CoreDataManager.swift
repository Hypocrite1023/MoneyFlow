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
    static func resetCoreDataStore() {
        let fileManager = FileManager.default
        let storeURL = NSPersistentContainer(name: "Model").persistentStoreDescriptions.first?.url

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
    func addTransaction(_ transaction: Transaction) -> Result<String?, AccountingError> {
        let dataIntegrityCheck = checkDataIntegrity(transactionDate: transaction.date, transactionType: transaction.type, transactionName: transaction.itemName, transactionAmount: transaction.amount.description, transactionCategory: transaction.category, transactionPaymentMethod: transaction.payMethod, transactionTag: transaction.tags, transactionNote: transaction.note, transactionRelationGoal: transaction.relationGoal)
        
        switch dataIntegrityCheck {
            
        case .success(_):
//            print(transaction)
            break
        case .failure(let error):
            return .failure(error)
        }
        let context = persistentContainer.viewContext
        let newTransaction = TransactionEntity(context: context)
        
        newTransaction.date = transaction.date
//        newTransaction.type = transaction.type
        newTransaction.itemName = transaction.itemName
        newTransaction.amount = transaction.amount
        newTransaction.note = transaction.note
        
        
        let typeFetchRequest: NSFetchRequest<TransactionType> = TransactionType.fetchRequest()
        typeFetchRequest.predicate = NSPredicate(format: "uuid == %@", transaction.type as CVarArg)
        if let type = try? context.fetch(typeFetchRequest).first {
            newTransaction.transactionType = type
        }
        
        let categoryFetchRequest: NSFetchRequest<TransactionCategory> = TransactionCategory.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "uuid == %@", transaction.category as CVarArg)
        if let category = try? context.fetch(categoryFetchRequest).first {
            newTransaction.transactionCategory = category
        }
        
        
        let paymentMethodFetchRequest: NSFetchRequest<TransactionPaymentMethod> = TransactionPaymentMethod.fetchRequest()
        paymentMethodFetchRequest.predicate = NSPredicate(format: "uuid == %@", transaction.payMethod as CVarArg)
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
                tagsFetchRequest.predicate = NSPredicate(format: "uuid == %@", transactionTag as CVarArg)
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
            return .failure(.someCheckingError)
        }
        return .success("accounting success")
    }
    
    func modifyTransaction(_ transaction: Transaction) -> Result<String?, AccountingError> {
        let dataIntegrityCheck = checkDataIntegrity(transactionDate: transaction.date, transactionType: transaction.type, transactionName: transaction.itemName, transactionAmount: transaction.amount.description, transactionCategory: transaction.category, transactionPaymentMethod: transaction.payMethod, transactionTag: transaction.tags, transactionNote: transaction.note, transactionRelationGoal: transaction.relationGoal)
        switch dataIntegrityCheck {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        guard let transactionID = transaction.id else { return .failure(.transactionIdNotExist)}
        fetchRequest.predicate = NSPredicate(format: "objectID == %@", transactionID)
        do {
            var transactionRecord = try context.existingObject(with: transactionID) as? TransactionEntity
            guard let transactionRecord else { return .failure(.transactionIdNotExist)}
            transactionRecord.date = transaction.date
//            transactionRecord.type = transaction.type
            transactionRecord.itemName = transaction.itemName
            transactionRecord.amount = transaction.amount
            transactionRecord.note = transaction.note
            
            let typeFetchRequest: NSFetchRequest<TransactionType> = TransactionType.fetchRequest()
            typeFetchRequest.predicate = NSPredicate(format: "uuid == %@", transaction.type as CVarArg)
            if let type = try? context.fetch(typeFetchRequest).first {
                transactionRecord.transactionType = type
            }
            
            let categoryFetchRequest: NSFetchRequest<TransactionCategory> = TransactionCategory.fetchRequest()
            categoryFetchRequest.predicate = NSPredicate(format: "uuid == %@ AND type == %@", transaction.category as CVarArg, transaction.type as CVarArg)
            if let category = try? context.fetch(categoryFetchRequest).first {
                transactionRecord.transactionCategory = category
            }
            
            let paymentMethodFetchRequest: NSFetchRequest<TransactionPaymentMethod> = TransactionPaymentMethod.fetchRequest()
            paymentMethodFetchRequest.predicate = NSPredicate(format: "uuid == %@", transaction.payMethod as CVarArg)
            if let paymentMethod = try? context.fetch(paymentMethodFetchRequest).first {
                transactionRecord.transactionPaymentMethod = paymentMethod
            }
            
            if let relationGoal = transaction.relationGoal {
                let goalFetchRequest: NSFetchRequest<GoalConfiguration> = GoalConfiguration.fetchRequest()
                goalFetchRequest.predicate = NSPredicate(format: "id == %@", relationGoal as CVarArg)
                if let goal = try? context.fetch(goalFetchRequest).first {
                    transactionRecord.goalRelation = goal
                }
            }
            
            var transactionTagSet: Set<TransactionTag> = []
            if let transactionTags = transaction.tags {
                for transactionTag in transactionTags {
                    let tagsFetchRequest: NSFetchRequest<TransactionTag> = TransactionTag.fetchRequest()
                    tagsFetchRequest.predicate = NSPredicate(format: "uuid == %@", transactionTag as CVarArg)
                    if let tag = try? context.fetch(tagsFetchRequest).first {
                        transactionTagSet.insert(tag)
                    }
                }
            }
            transactionRecord.transactionTag = transactionTagSet as NSSet
            
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        return .success("Modify transaction successfully")
    }
    
//    func fetchAllTransactions() -> [Transaction]? {
//        let context = persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
//        
//        do {
//            let transactionEntities = try context.fetch(fetchRequest)
//            return transactionEntities.map({
//                let tags = $0.transactionTag?.compactMap{ (tag) -> String? in
//                    guard let tag = tag as? TransactionTag else { return nil }
//                    return tag.name
//                }
//                let transaction = Transaction(date: $0.date!,
//                                              type: $0.type!,
//                                              itemName: $0.itemName!,
//                                              amount: $0.amount,
//                                              category: ($0.incomeTransactionCategory?.category)!,
//                                              payMethod: ($0.transactionPaymentMethod?.paymentMethod)!,
//                                              tags: tags,
//                                              note: $0.note, relationGoal: nil)
//                return transaction
//            })
//            
//        } catch {
//            print(error.localizedDescription)
//        }
//        return nil
//    }
    
    func fetchTransaction(withPredicate: (transactionPredicate: NSPredicate?, typePredicate: NSPredicate?,  categoryPredicate: NSPredicate?, paymentMethodPredicate: NSPredicate?, tagPredicate: NSPredicate?)) -> [Transaction] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        fetchRequest.predicate = withPredicate.transactionPredicate
        
        let typeFetchRequest: NSFetchRequest<TransactionType> = TransactionType.fetchRequest()
        typeFetchRequest.predicate = withPredicate.typePredicate
        guard let type = try? context.fetch(typeFetchRequest) else {
            return []
        }
        
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
                
                if !categories.contains($0.transactionCategory!) || !paymentMethods.contains($0.transactionPaymentMethod!) || !type.contains($0.transactionType!) {
                    return nil
                }
                
                
                // 當 transactionTag's predicate is nil -> 代表沒選任何tag -> transaction 有tag 沒tag都要列出
                // 當 transactionTag's predicate is not nil -> 有篩選tag -> 列出的transaction 的 tag 要是 選擇的tag的子集合 -> 但是又不能列出 transaction 的 tag 是 nil 的
//                print(Set(set), set2, !Set(set2).isSubset(of: set) || Set(set2).isEmpty, withPredicate.tagPredicate != nil)
                
                if (!Set(set2).isSubset(of: set) || Set(set2).isEmpty && withPredicate.tagPredicate != nil) {
                    return nil
                }
                
                
                let tags = $0.transactionTag?.compactMap{ (tag) -> UUID? in
                    guard let tag = tag as? TransactionTag else { return nil }
                    return tag.uuid
                }
                var transaction = Transaction(date: $0.date!,
                                              type: ($0.transactionType?.uuid)!,
                                              itemName: $0.itemName!,
                                              amount: $0.amount,
                                              category: ($0.transactionCategory?.uuid)!,
                                              categorySystemImageName: $0.transactionCategory?.systemImage,
                                              payMethod: ($0.transactionPaymentMethod?.uuid)!,
                                              tags: tags,
                                              note: $0.note, relationGoal: nil)
                transaction.id = $0.objectID
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
                let tags = $0.transactionTag?.compactMap{ (tag) -> UUID? in
                    guard let tag = tag as? TransactionTag else { return nil }
                    return tag.uuid
                }
                var transaction = Transaction(date: $0.date!,
                                              type: ($0.transactionType?.uuid)!,
                                              itemName: $0.itemName!,
                                              amount: $0.amount,
                                              category: ($0.transactionCategory?.uuid)!,
                                              categorySystemImageName: $0.transactionCategory?.systemImage,
                                              payMethod: ($0.transactionPaymentMethod?.uuid)!,
                                              tags: tags,
                                              note: $0.note, relationGoal: nil)
                transaction.id = $0.objectID
                return transaction
            })
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func fetchTransactionWith(withSpecifyDateRange: (start: Date, end: Date), type: CoreDataPredicate.CoreDataPredicateTransactionType) -> [Transaction]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        let datePredicate = NSPredicate(format: "(date >= %@) AND (date < %@)", withSpecifyDateRange.start as NSDate, withSpecifyDateRange.end as NSDate)
        let typePredicate = type.predicate
        let typeFetchRequest: NSFetchRequest<TransactionType> = TransactionType.fetchRequest()
        typeFetchRequest.predicate = typePredicate
        guard let type = try? context.fetch(typeFetchRequest) else {
            return []
        }
//        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, typePredicate])
//        print(predicate)
        fetchRequest.predicate = datePredicate
        do {
            let transactionEntities = try context.fetch(fetchRequest)
            return transactionEntities.compactMap({
                if !type.contains($0.transactionType!) { return nil }
                let tags = $0.transactionTag?.compactMap{ (tag) -> UUID? in
                    guard let tag = tag as? TransactionTag else { return nil }
                    return tag.uuid
                }
                var transaction = Transaction(date: $0.date!,
                                              type: ($0.transactionType?.uuid)!,
                                              itemName: $0.itemName!,
                                              amount: $0.amount,
                                              category: ($0.transactionCategory?.uuid)!,
                                              categorySystemImageName: $0.transactionCategory?.systemImage,
                                              payMethod: ($0.transactionPaymentMethod?.uuid)!,
                                              tags: tags,
                                              note: $0.note, relationGoal: nil)
                transaction.id = $0.objectID
                return transaction
            })
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func fetchTransactionByYearMonth(year: Int, month: Int) -> [Transaction] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let startDate = calendar.date(from: components),
              let endDate = calendar.date(byAdding: .month, value: 1, to: startDate) else {
            return []
        }
        
        let datePredicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
        
        fetchRequest.predicate = datePredicate
        do {
            let transactionEntities = try context.fetch(fetchRequest)
            return transactionEntities.map({
                let tags = $0.transactionTag?.compactMap{ (tag) -> UUID? in
                    guard let tag = tag as? TransactionTag else { return nil }
                    return tag.uuid
                }
                var transaction = Transaction(date: $0.date!,
                                              type: ($0.transactionType?.uuid)!,
                                              itemName: $0.itemName!,
                                              amount: $0.amount,
                                              category: ($0.transactionCategory?.uuid)!,
                                              categorySystemImageName: $0.transactionCategory?.systemImage,
                                              payMethod: ($0.transactionPaymentMethod?.uuid)!,
                                              tags: tags,
                                              note: $0.note, relationGoal: nil)
                transaction.id = $0.objectID
                return transaction
            })
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}
// MARK: - Transaction Category
extension CoreDataManager {
    func fetchTransactionCategories(predicate: CoreDataPredicate.TransactionCategory) -> [CoreDataTransactionCategory] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionCategory> = TransactionCategory.fetchRequest()
        fetchRequest.predicate = predicate.predicate
        do {
            let categories = try context.fetch(fetchRequest)
            return categories.compactMap {
                CoreDataTransactionCategory(name: $0.category!, uuid: $0.uuid!, systemImage: $0.systemImage ?? nil)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}
// MARK: - Transaction Payment Method
extension CoreDataManager {
    func fetchAllTransactionPaymentMethods() -> [CoreDataTransactionPaymentMethod] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionPaymentMethod> = TransactionPaymentMethod.fetchRequest()
        
        do {
            let paymentMethods = try context.fetch(fetchRequest)
            return paymentMethods.compactMap {
                CoreDataTransactionPaymentMethod(paymentMethod: $0.paymentMethod!, uuid: $0.uuid!)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}
// MARK: - Transaction Tags
extension CoreDataManager {
    func fetchAllTransactionTags() -> [CoreDataTransactionTag] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionTag> = TransactionTag.fetchRequest()
        
        do {
            let tags = try context.fetch(fetchRequest)
//            print(tags.compactMap({$0.name}), "tags")
            let result = tags.compactMap {
                CoreDataTransactionTag(tag: $0.name!, uuid: $0.uuid!)
            }
            return result
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
    
    func modifyGoal(objectID: NSManagedObjectID, goal: GoalItem) {
        let context = persistentContainer.viewContext
        do {
            guard var targetGoal = try context.existingObject(with: objectID) as? GoalConfiguration else {
                return
            }
            targetGoal.goalName = goal.name
            targetGoal.goalAmount = goal.targetAmount
            targetGoal.goalStartDate = goal.startDate
            targetGoal.goalEndDate = goal.endDate
            
            try context.save()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchAllGoalsStatus() -> [GoalItem] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<GoalConfiguration> = GoalConfiguration.fetchRequest()
        do {
            let goals = try context.fetch(fetchRequest)
            return goals.map {
                let predicate = NSPredicate(format: "goalRelation == %@", $0)
                if let transactions = fetchTransaction(withPredicate: predicate) {
                    let currentAmount = transactions.reduce(0) { $0 + $1.amount }
                    return GoalItem(objectID: $0.objectID, id: $0.id!, name: $0.goalName, startDate: $0.goalStartDate!, endDate: $0.goalEndDate, targetAmount: $0.goalAmount, currentAmount: currentAmount)
                } else {
                    return GoalItem(objectID: $0.objectID, id: $0.id!, name: $0.goalName, startDate: $0.goalStartDate!, endDate: $0.goalEndDate, targetAmount: $0.goalAmount, currentAmount: 0)
                }
                
                
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchInProcessGoal() -> [GoalItem] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<GoalConfiguration> = GoalConfiguration.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "goalEndDate > %@ || goalEndDate == nil", Date.now as NSDate)
        do {
            let goals = try context.fetch(fetchRequest)
            return goals.map {
                let predicate = NSPredicate(format: "goalRelation == %@", $0)
                if let transactions = fetchTransaction(withPredicate: predicate) {
                    let currentAmount = transactions.reduce(0) { $0 + $1.amount }
                    return GoalItem(objectID: $0.objectID, id: $0.id!, name: $0.goalName, startDate: $0.goalStartDate!, endDate: $0.goalEndDate, targetAmount: $0.goalAmount, currentAmount: currentAmount)
                } else {
                    return GoalItem(objectID: $0.objectID, id: $0.id!, name: $0.goalName, startDate: $0.goalStartDate!, endDate: $0.goalEndDate, targetAmount: $0.goalAmount, currentAmount: 0)
                }
                
                
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchGoalAllRelationTransaction(objectID: NSManagedObjectID) -> [Transaction] {
        let context = persistentContainer.viewContext
        do {
            guard let goal = try context.existingObject(with: objectID) as? GoalConfiguration else {
                return []
            }
            guard let transactions = goal.savings as? Set<TransactionEntity> else {
                return []
            }
            
            return transactions.map {
                let tags = $0.transactionTag?.compactMap{ (tag) -> UUID? in
                    guard let tag = tag as? TransactionTag else { return nil }
                    return tag.uuid
                }
                var transaction = Transaction(date: $0.date!,
                                              type: ($0.transactionType?.uuid)!,
                                              itemName: $0.itemName!,
                                              amount: $0.amount,
                                              category: ($0.transactionCategory?.uuid)!,
                                              payMethod: ($0.transactionPaymentMethod?.uuid)!,
                                              tags: tags,
                                              note: $0.note, relationGoal: nil)
                transaction.id = $0.objectID
                return transaction
            }
        } catch {
            
        }
        return []
    }
}
// MARK: - Transaction Type
extension CoreDataManager {
    func fetchAllTransactionType() -> [CoreDataTransactionType] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionType> = TransactionType.fetchRequest()
        do {
            let types = try context.fetch(fetchRequest)
            return types.map {
                CoreDataTransactionType(nsLocalizedStringIdentifier: $0.type!, uuid: $0.uuid!)
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}

// MARK: - 資料檢查
extension CoreDataManager {
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
        case transactionIdNotExist
        
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
            case .transactionIdNotExist:
                return "該筆資料不存在"
            }
        }
    }
    
    func checkDataIntegrity(transactionDate: Date?, transactionType: UUID?, transactionName: String?, transactionAmount: String?, transactionCategory: UUID?, transactionPaymentMethod: UUID?, transactionTag: [UUID]?, transactionNote: String?, transactionRelationGoal: UUID?) -> Result<String?, AccountingError> {
        
        func transactionTypeChecking() -> Result<String?, AccountingError> {
            guard let transactionType else {
                return .failure(.transactionTypeNotSelect)
            }
            return .success(nil)
        }
        
        func transactionNameChecking() -> Result<String?, AccountingError> {
            guard let transactionName else {
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
            guard transactionCategory != nil else {
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
        
        switch transactionTypeChecking() {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        switch transactionNameChecking() {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        switch transactionAmountChecking() {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        switch transactionCategoryChecking() {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        switch transactionPaymentMethodChecking() {
            
        case .success(let message):
            return .success(message)
        case .failure(let error):
            return .failure(error)
        }
    }
}

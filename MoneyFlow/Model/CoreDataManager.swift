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
    
    private init() {
//        ValueTransformer.setValueTransformer(TransactionTypeTransformer(), forName: NSValueTransformerName(rawValue: "TransactionTypeTransformer"))
        
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
        newTransaction.setValue(transaction.amount, forKey: "amount")
        newTransaction.setValue(transaction.date, forKey: "date")
        newTransaction.setValue(transaction.type.rawValue, forKey: "type")
        save()
    }
}

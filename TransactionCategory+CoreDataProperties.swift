//
//  TransactionCategory+CoreDataProperties.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/13.
//
//

import Foundation
import CoreData


extension TransactionCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionCategory> {
        return NSFetchRequest<TransactionCategory>(entityName: "TransactionCategory")
    }

    @NSManaged public var category: String?
    @NSManaged public var deletable: Bool
    @NSManaged public var systemImage: String?
    @NSManaged public var type: UUID?
    @NSManaged public var uuid: UUID?
    @NSManaged public var transactionEntity: NSSet?

}

// MARK: Generated accessors for transactionEntity
extension TransactionCategory {

    @objc(addTransactionEntityObject:)
    @NSManaged public func addToTransactionEntity(_ value: TransactionEntity)

    @objc(removeTransactionEntityObject:)
    @NSManaged public func removeFromTransactionEntity(_ value: TransactionEntity)

    @objc(addTransactionEntity:)
    @NSManaged public func addToTransactionEntity(_ values: NSSet)

    @objc(removeTransactionEntity:)
    @NSManaged public func removeFromTransactionEntity(_ values: NSSet)

}

extension TransactionCategory : Identifiable {

}

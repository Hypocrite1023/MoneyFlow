//
//  TransactionEntity+CoreDataProperties.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/13.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var itemName: String?
    @NSManaged public var note: String?
    @NSManaged public var type: UUID?
    @NSManaged public var goalRelation: GoalConfiguration?
    @NSManaged public var transactionCategory: TransactionCategory?
    @NSManaged public var transactionPaymentMethod: TransactionPaymentMethod?
    @NSManaged public var transactionTag: NSSet?

}

// MARK: Generated accessors for transactionTag
extension TransactionEntity {

    @objc(addTransactionTagObject:)
    @NSManaged public func addToTransactionTag(_ value: TransactionTag)

    @objc(removeTransactionTagObject:)
    @NSManaged public func removeFromTransactionTag(_ value: TransactionTag)

    @objc(addTransactionTag:)
    @NSManaged public func addToTransactionTag(_ values: NSSet)

    @objc(removeTransactionTag:)
    @NSManaged public func removeFromTransactionTag(_ values: NSSet)

}

extension TransactionEntity : Identifiable {

}

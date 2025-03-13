//
//  TransactionTag+CoreDataProperties.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/13.
//
//

import Foundation
import CoreData


extension TransactionTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionTag> {
        return NSFetchRequest<TransactionTag>(entityName: "TransactionTag")
    }

    @NSManaged public var name: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var transactionEntity: NSSet?

}

// MARK: Generated accessors for transactionEntity
extension TransactionTag {

    @objc(addTransactionEntityObject:)
    @NSManaged public func addToTransactionEntity(_ value: TransactionEntity)

    @objc(removeTransactionEntityObject:)
    @NSManaged public func removeFromTransactionEntity(_ value: TransactionEntity)

    @objc(addTransactionEntity:)
    @NSManaged public func addToTransactionEntity(_ values: NSSet)

    @objc(removeTransactionEntity:)
    @NSManaged public func removeFromTransactionEntity(_ values: NSSet)

}

extension TransactionTag : Identifiable {

}

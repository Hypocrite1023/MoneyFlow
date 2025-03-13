//
//  TransactionPaymentMethod+CoreDataProperties.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/13.
//
//

import Foundation
import CoreData


extension TransactionPaymentMethod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionPaymentMethod> {
        return NSFetchRequest<TransactionPaymentMethod>(entityName: "TransactionPaymentMethod")
    }

    @NSManaged public var paymentMethod: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var transactionEntity: NSSet?

}

// MARK: Generated accessors for transactionEntity
extension TransactionPaymentMethod {

    @objc(addTransactionEntityObject:)
    @NSManaged public func addToTransactionEntity(_ value: TransactionEntity)

    @objc(removeTransactionEntityObject:)
    @NSManaged public func removeFromTransactionEntity(_ value: TransactionEntity)

    @objc(addTransactionEntity:)
    @NSManaged public func addToTransactionEntity(_ values: NSSet)

    @objc(removeTransactionEntity:)
    @NSManaged public func removeFromTransactionEntity(_ values: NSSet)

}

extension TransactionPaymentMethod : Identifiable {

}

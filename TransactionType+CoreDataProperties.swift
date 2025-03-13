//
//  TransactionType+CoreDataProperties.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/13.
//
//

import Foundation
import CoreData


extension TransactionType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionType> {
        return NSFetchRequest<TransactionType>(entityName: "TransactionType")
    }

    @NSManaged public var type: String?
    @NSManaged public var uuid: UUID?

}

extension TransactionType : Identifiable {

}

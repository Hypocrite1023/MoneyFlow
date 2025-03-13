//
//  GoalConfiguration+CoreDataProperties.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/13.
//
//

import Foundation
import CoreData


extension GoalConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalConfiguration> {
        return NSFetchRequest<GoalConfiguration>(entityName: "GoalConfiguration")
    }

    @NSManaged public var goalAmount: Double
    @NSManaged public var goalEndDate: Date?
    @NSManaged public var goalName: String?
    @NSManaged public var goalStartDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var savings: NSSet?

}

// MARK: Generated accessors for savings
extension GoalConfiguration {

    @objc(addSavingsObject:)
    @NSManaged public func addToSavings(_ value: TransactionEntity)

    @objc(removeSavingsObject:)
    @NSManaged public func removeFromSavings(_ value: TransactionEntity)

    @objc(addSavings:)
    @NSManaged public func addToSavings(_ values: NSSet)

    @objc(removeSavings:)
    @NSManaged public func removeFromSavings(_ values: NSSet)

}

extension GoalConfiguration : Identifiable {

}

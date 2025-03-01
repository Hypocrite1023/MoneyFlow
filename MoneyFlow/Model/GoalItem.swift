//
//  GoldItem.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/19.
//

import Foundation
import CoreData

struct GoalItem: Hashable {
    var objectID: NSManagedObjectID?
    let id: UUID  // 用於唯一標識目標
    let name: String?
    var startDate: Date
    var endDate: Date?
    let targetAmount: Double
    let currentAmount: Double
}

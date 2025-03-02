//
//  GoalDetailViewViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/28.
//

import Foundation

class GoalDetailViewViewModel {
    var goal: GoalItem
    @Published var name: String?
    @Published var startDate: Date
    @Published var endDate: Date?
    @Published var targetAmount: Double
    @Published var currentAmount: Double
    @Published var relationTransaction: [Transaction] = []
    
    init(goal: GoalItem) {
        self.goal = goal
        self.name = goal.name
        self.startDate = goal.startDate
        self.endDate = goal.endDate
        self.targetAmount = goal.targetAmount
        self.currentAmount = goal.currentAmount
    }
    
    enum DateSection: Hashable {
        case date(String)
    }
    
    func reloadRelationTransaction() {
        relationTransaction = CoreDataManager.shared.fetchGoalAllRelationTransaction(objectID: goal.objectID!)
        currentAmount = relationTransaction.reduce(0) { $0 + $1.amount }
    }
}

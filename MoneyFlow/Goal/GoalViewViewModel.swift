//
//  GoalViewViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/27.
//

import Foundation

class GoalViewViewModel {
    @Published var goalList: [GoalItem]
    
    init() {
        self.goalList = CoreDataManager.shared.fetchAllGoalsStatus()
    }
    
    func reloadGoal() {
        goalList = CoreDataManager.shared.fetchAllGoalsStatus()
    }
}

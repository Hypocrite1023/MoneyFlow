//
//  GoalViewViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/27.
//

import Foundation

class GoalViewViewModel {
    @Published var goalList: [GoalItem]
    
    @Published var dailyGoal: Double?
    @Published var weeklyGoal: Double?
    @Published var monthlyGoal: Double?
    
    @Published var currentDailyExpense: Double = 0
    @Published var currentWeeklyExpense: Double = 0
    @Published var currentMonthlyExpense: Double = 0
    
    init() {
        self.goalList = CoreDataManager.shared.fetchAllGoalsStatus()
//        UserDefaults.standard.removeObject(forKey: AppConfig.UserDefaultKey.dailyExpenseLimit.rawValue)
//        UserDefaults.standard.removeObject(forKey: AppConfig.UserDefaultKey.weeklyExpenseLimit.rawValue)
//        UserDefaults.standard.removeObject(forKey: AppConfig.UserDefaultKey.monthlyExpenseLimit.rawValue)
    }
    
    func reloadGoal() {
        goalList = CoreDataManager.shared.fetchAllGoalsStatus()
    }
    
    func loadDailyWeeklyMonthlyGoal() {
        if let dailyGoalValue = UserDefaults.standard.object(forKey: AppConfig.UserDefaultKey.dailyExpenseLimit.rawValue) {
            dailyGoal = dailyGoalValue as? Double
        }
        if let weeklyGoalValue = UserDefaults.standard.object(forKey: AppConfig.UserDefaultKey.weeklyExpenseLimit.rawValue) as? Double {
            weeklyGoal = weeklyGoalValue
        }
        if let monthlyGoalValue = UserDefaults.standard.object(forKey: AppConfig.UserDefaultKey.monthlyExpenseLimit.rawValue) as? Double {
            monthlyGoal = monthlyGoalValue
        }
    }
    
    func loadCurrentExpense() {
        currentDailyExpense = CoreDataManager.shared.fetchTransaction(withPredicate: (CoreDataPredicate.TransactionDateRange.today.expensePredicate, nil, nil, nil)).reduce(0) { $0 + $1.amount }
        currentWeeklyExpense = CoreDataManager.shared.fetchTransaction(withPredicate: (CoreDataPredicate.TransactionDateRange.thisWeek.expensePredicate, nil, nil, nil)).reduce(0) { $0 + $1.amount }
        currentMonthlyExpense = CoreDataManager.shared.fetchTransaction(withPredicate: (CoreDataPredicate.TransactionDateRange.thisMonth.expensePredicate, nil, nil, nil)).reduce(0) { $0 + $1.amount }
    }
}

//
//  SettingExpenseGoalViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/2.
//

import Foundation

class SettingExpenseGoalViewModel {
    @Published var dailyGoal: String
    @Published var weeklyGoal: String
    @Published var monthlyGoal: String
    
    let originalDailyGoal: String
    let originalWeeklyGoal: String
    let originalMonthlyGoal: String
    
    enum ExpenseGoalError: Error {
        case invalidInput(String)
        
        var info: String {
            switch self {
            case .invalidInput(let str):
                return "請在每\(str)花費目標輸入正確的數字"
            }
        }
    }
    
    enum ExpenseStatus {
        case success, fail
    }
    
    init() {
        if let dailyGoalValue = UserDefaults.standard.object(forKey: AppConfig.UserDefaultKey.dailyExpenseLimit.rawValue), let dailyGoalDoubleValue = dailyGoalValue as? Double {
            dailyGoal = dailyGoalDoubleValue.description
            originalDailyGoal = dailyGoalDoubleValue.description
        } else {
            dailyGoal = ""
            originalDailyGoal = ""
        }
        if let weeklyGoalValue = UserDefaults.standard.object(forKey: AppConfig.UserDefaultKey.weeklyExpenseLimit.rawValue), let weeklyGoalDoubleValue = weeklyGoalValue as? Double {
            weeklyGoal = weeklyGoalDoubleValue.description
            originalWeeklyGoal = weeklyGoalDoubleValue.description
        } else {
            weeklyGoal = ""
            originalWeeklyGoal = ""
        }
        if let monthlyGoalValue = UserDefaults.standard.object(forKey: AppConfig.UserDefaultKey.monthlyExpenseLimit.rawValue), let monthlyGoalDoubleValue = monthlyGoalValue as? Double {
            monthlyGoal = monthlyGoalDoubleValue.description
            originalMonthlyGoal = monthlyGoalDoubleValue.description
        } else {
            monthlyGoal = ""
            originalMonthlyGoal = ""
        }
    }
    
    func setExpenseGoal() -> Result<String?, ExpenseGoalError> {
        if !(dailyGoal == originalDailyGoal) {
            switch checkExpenseGoal(value: dailyGoal, type: "日") {
                
            case .success(_):
                
                UserDefaults.standard.set(Double(dailyGoal), forKey: AppConfig.UserDefaultKey.dailyExpenseLimit.rawValue)
                
            case .failure(let error):
                return .failure(error)
            }
        }
        if !(weeklyGoal == originalWeeklyGoal) {
            switch checkExpenseGoal(value: weeklyGoal, type: "週") {
                
            case .success(_):
                
                UserDefaults.standard.set(Double(weeklyGoal), forKey: AppConfig.UserDefaultKey.weeklyExpenseLimit.rawValue)
                
            case .failure(let error):
                return .failure(error)
            }
        }
        if !(monthlyGoal == originalMonthlyGoal) {
            switch checkExpenseGoal(value: monthlyGoal, type: "月") {
                
            case .success(_):
                
                UserDefaults.standard.set(Double(monthlyGoal), forKey: AppConfig.UserDefaultKey.monthlyExpenseLimit.rawValue)
                
            case .failure(let error):
                return .failure(error)
            }
        }
        return .success(nil)
    }
    
    func checkExpenseGoal(value: String, type: String) -> Result<String?, ExpenseGoalError> {
        guard let _ = Double(value) else {
            return .failure(.invalidInput(type))
        }
        return .success(nil)
    }
}

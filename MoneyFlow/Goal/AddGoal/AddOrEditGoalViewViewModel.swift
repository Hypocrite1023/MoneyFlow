//
//  AddOrEditGoalViewViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/1.
//

import Foundation
import CoreData

class AddOrEditGoalViewViewModel {
    var mode: AddOrEditGoalViewMode
    let originGoal: GoalItem?
    let objectID: NSManagedObjectID?
    @Published var name: String?
    @Published var amount: String?
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var noEndDate: Bool?
    
    typealias GoalOperateResult = Result<String?, GoalFaliureReason>
    
    init(mode: AddOrEditGoalViewMode, goal: GoalItem? = nil) {
        self.mode = mode
        guard let goal else {
            self.objectID = nil
            self.originGoal = nil
            return
        }
        self.originGoal = goal
        self.objectID = goal.objectID
        self.name = goal.name
        self.amount = goal.targetAmount.description
        self.startDate = goal.startDate
        self.endDate = goal.endDate
        self.noEndDate = goal.endDate == nil
    }
    
    func addGoal() -> GoalOperateResult {
        switch checkValidity() {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        CoreDataManager.shared.addGoal(name!, amount: Double(amount!)!, startDate: startDate!, endDate: noEndDate! ? nil : endDate!)
        
        return .success(nil)
    }
    
    func modifyGoal() -> GoalOperateResult {
        print(endDate)
        guard let objectID else {
            return .failure(.objectIdNil)
        }
        
        switch checkValidity() {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        if !isGoalModified() {
            return .success(nil)
        }
        
        guard let originGoal else { return .failure(.goalNil) }
        print(GoalItem(id: originGoal.id, name: name!, startDate: startDate!, endDate: noEndDate! ? nil : endDate!, targetAmount: Double(amount!)!, currentAmount: 0))
        CoreDataManager.shared.modifyGoal(objectID: objectID, goal: GoalItem(id: originGoal.id, name: name!, startDate: startDate!, endDate: noEndDate! ? nil : endDate!, targetAmount: Double(amount!)!, currentAmount: 0))
        
        return .success(nil)
    }
    
    func checkValidity() -> GoalOperateResult {
        func checkGoalName() -> GoalOperateResult {
            guard let name = name, !name.isEmpty else {
                return .failure(.nameEmpty)
            }
            return .success(nil)
        }
        
        func checkGoalAmount() -> GoalOperateResult {
            guard let amount = amount, !amount.isEmpty else {
                return .failure(.amountEmpty)
            }
            guard Double(amount) != nil else {
                return .failure(.amountInvalid)
            }
            return .success(nil)
        }
        
        func checkGoalStartDate() -> GoalOperateResult {
            guard startDate != nil else {
                return .failure(.startDateEmpty)
            }
            return .success(nil)
        }
        
        func checkGoalEndDate() -> GoalOperateResult {
            if let noEndDate {
                if noEndDate == false {
                    if let endDate, endDate < startDate! {
                        return .failure(.endDateEarlyThanStartDate)
                    } else {
                        return .success(nil)
                    }
                } else {
                    return .success(nil)
                }
                
            } else {
                return .failure(.noEndDateError)
            }
            
        }
        
        switch checkGoalName() {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        switch checkGoalAmount() {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        switch checkGoalStartDate() {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        switch checkGoalEndDate() {
            
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        
        return .success(nil)
    }
    
    func isGoalModified() -> Bool {
        guard let originGoal else { return false }
        if name != originGoal.name || Double(amount!)! != originGoal.targetAmount || startDate != originGoal.startDate || endDate != originGoal.endDate {
            return true
        } else {
            return false
        }
    }
}

enum GoalFaliureReason: Error {
    case nameEmpty
    case amountEmpty
    case amountInvalid
    case startDateEmpty
    case endDateEarlyThanStartDate
    case noEndDateError
    case objectIdNil
    case goalNil
    
    var infoMessage: String {
        switch self {
            
        case .nameEmpty:
            return NSLocalizedString("AddOrEditGoalView_GoalFaliureReason_NameEmpty_Title", comment: "")
        case .amountEmpty:
            return NSLocalizedString("AddOrEditGoalView_GoalFaliureReason_AmountEmpty_Title", comment: "")
        case .amountInvalid:
            return NSLocalizedString("AddOrEditGoalView_GoalFaliureReason_AmountInvalid_Title", comment: "")
        case .startDateEmpty:
            return NSLocalizedString("AddOrEditGoalView_GoalFaliureReason_StartDateEmpty_Title", comment: "")
        case .endDateEarlyThanStartDate:
            return NSLocalizedString("AddOrEditGoalView_GoalFaliureReason_EndDateEarlyThanStartDate_Title", comment: "")
        case .noEndDateError:
            return NSLocalizedString("AddOrEditGoalView_GoalFaliureReason_NoEndDateError_Title", comment: "")
        case .objectIdNil:
            return NSLocalizedString("AddOrEditGoalView_GoalFaliureReason_ObjectIdNil_Title", comment: "")
        case .goalNil:
            return NSLocalizedString("AddOrEditGoalView_GoalFaliureReason_GoalNil_Title", comment: "")
        }
    }
}

enum AddOrEditGoalViewMode {
    case add
    case edit
}

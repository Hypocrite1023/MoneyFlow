//
//  AddGoalViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/17.
//

import UIKit

class AddGoalViewController: UIViewController {
    
    private var addGoalView: AddGoalView?
    
    override func loadView() {
        super.loadView()
        view = AddGoalView(frame: .zero)
        addGoalView = view as? AddGoalView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addGoalView?.closeButton.addTarget(self, action: #selector(closeAddGoalView), for: .touchUpInside)
        addGoalView?.setButton.addTarget(self, action: #selector(setAGoal), for: .touchUpInside)
        
        addGoalView?.goalTimePeriodSwitch.addTarget(self, action: #selector(goalTimePeriodSwitchDidChange), for: .valueChanged)
        let closeKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(closeKeyboardGesture)
    }
    
    @objc func closeAddGoalView() {
        self.dismiss(animated: true)
    }
    
    @objc func setAGoal() {
        self.dismiss(animated: true)
        let conf = getUserConfiguration()
        CoreDataManager.shared.addGoal(conf.name, amount: conf.amount, startDate: conf.startDate, endDate: conf.endDate)
    }
    
    @objc func goalTimePeriodSwitchDidChange(sender: UISwitch) {
        if sender.isOn {
            addGoalView?.goalTimePeriodEndDatePicker.isHidden = true
            addGoalView?.goalTimePeriodInfiniteReplaceDatePickerLabel.isHidden = false
        } else {
            addGoalView?.goalTimePeriodEndDatePicker.isHidden = false
            addGoalView?.goalTimePeriodInfiniteReplaceDatePickerLabel.isHidden = true
        }
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    private func getUserConfiguration() -> (name: String, amount: Double, startDate: Date, endDate: Date?) {
        let name: String = (addGoalView?.goalNameTextField.text)!
        let amount: Double = Double((addGoalView?.goalAmountTextField.text)!)!
        let startDate: Date = (addGoalView?.goalTimePeriodStartDatePicker.date)!
        let endDate: Date? = (addGoalView?.goalTimePeriodSwitch.isOn)! == true ? nil : addGoalView?.goalTimePeriodEndDatePicker.date
        
        return (name, amount, startDate, endDate)
    }
    
}

//
//  AddGoalView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/17.
//

import UIKit

class AddOrEditGoalView: UIView {
    
    let mode: AddOrEditGoalViewMode

    let closeButton: UIButton = UIButton(configuration: .plain())
    let setButton: UIButton = UIButton(configuration: .plain())
    private var buttonPanelStackView: UIStackView?
    
    private let goalNameLabel: UILabel = UILabel()
    let goalNameTextField: UITextField = UITextField()
    private var goalNameStackView: UIStackView?
    
    private let goalAmountLabel: UILabel = UILabel()
    let goalAmountTextField: UITextField = UITextField()
    private let goalAmountTextFieldKeyboardDoneButton: UIToolbar = UIToolbar()
    let goalAmountTextFieldKeyboardDoneButtonItem: UIBarButtonItem = UIBarButtonItem()
    private var goalAmountStackView: UIStackView?
    
    private let goalTimePeriodLabel: UILabel = UILabel()
    private let goalTimePeriodInfiniteLabel: UILabel = UILabel()
    let goalTimePeriodSwitch: UISwitch = UISwitch()
    private var goalTimePeriodSwitchStackView: UIStackView?
    private var goalTimePeriodLabelAndSwitchStackView: UIStackView?

    let goalTimePeriodStartDatePicker: UIDatePicker = UIDatePicker()
    private let goalTimePeriodToDateLabel: UILabel = UILabel()
    let goalTimePeriodEndDatePicker: UIDatePicker = UIDatePicker()
    let goalTimePeriodInfiniteReplaceDatePickerLabel: UILabel = UILabel()
    private var goalTimePeriodDatePickerStackView: UIStackView?
    
    private var goalTimePeriodStackView: UIStackView?
    
//    private let isPeriodGoalLabel: UILabel = UILabel()
//    let isPeriodGoalSegmentedControl: UISegmentedControl = UISegmentedControl(items: ["是", "否"])
//    private var isPeriodGoalStackView: UIStackView?
    
    private var wholePageStackView: UIStackView?
    
    init(mode: AddOrEditGoalViewMode) {
        self.mode = mode
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        backgroundColor = .white
        
        closeButton.setTitle("取消", for: .normal)
        closeButton.tintColor = .systemRed
        
        switch mode {
            
        case .add:
            setButton.setTitle("設定", for: .normal)
            setButton.tintColor = .systemBlue
        case .edit:
            setButton.setTitle("修改", for: .normal)
            setButton.tintColor = .systemOrange
        }
        buttonPanelStackView = UIStackView(arrangedSubviews: [closeButton, setButton])
        buttonPanelStackView!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonPanelStackView!)
        buttonPanelStackView!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonPanelStackView!.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        goalNameLabel.text = "目標名稱"
        goalNameLabel.font = AppConfig.Font.title.value
        
        goalNameTextField.borderStyle = .roundedRect
        
        
        goalNameStackView = UIStackView(arrangedSubviews: [goalNameLabel, goalNameTextField])
        goalNameStackView?.axis = .vertical
        goalNameStackView?.spacing = 8
        
        
        
        goalAmountLabel.text = "目標金額"
        goalAmountLabel.font = AppConfig.Font.title.value
        
        goalAmountTextField.borderStyle = .roundedRect
        goalAmountTextField.keyboardType = .numberPad
        
        goalAmountTextFieldKeyboardDoneButton.sizeToFit()
        goalAmountTextFieldKeyboardDoneButtonItem.title = "完成"
        goalAmountTextFieldKeyboardDoneButtonItem.style = .done
        goalAmountTextFieldKeyboardDoneButton.setItems([UIBarButtonItem(systemItem: .flexibleSpace), goalAmountTextFieldKeyboardDoneButtonItem], animated: true)
        goalAmountTextField.inputAccessoryView = goalAmountTextFieldKeyboardDoneButton
        
        goalAmountStackView = UIStackView(arrangedSubviews: [goalAmountLabel, goalAmountTextField])
        goalAmountStackView?.axis = .vertical
        goalAmountStackView?.spacing = 8
        
        
        goalTimePeriodLabel.text = "目標持續時間"
        goalTimePeriodLabel.font = AppConfig.Font.title.value
        
        goalTimePeriodInfiniteLabel.text = "目標無結束時間"
        goalTimePeriodInfiniteLabel.font = AppConfig.Font.tertiaryTitle.value
        
        goalTimePeriodSwitchStackView = UIStackView(arrangedSubviews: [goalTimePeriodInfiniteLabel, goalTimePeriodSwitch])
        goalTimePeriodSwitchStackView?.axis = .horizontal
        goalTimePeriodSwitchStackView?.spacing = 5
        
        goalTimePeriodLabelAndSwitchStackView = UIStackView()
        goalTimePeriodLabelAndSwitchStackView?.axis = .horizontal
        
        let flexHorizonView = UIView()
        flexHorizonView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        goalTimePeriodLabelAndSwitchStackView?.addArrangedSubview(goalTimePeriodLabel)
        goalTimePeriodLabelAndSwitchStackView?.addArrangedSubview(flexHorizonView)
        goalTimePeriodLabelAndSwitchStackView?.addArrangedSubview(goalTimePeriodSwitchStackView!)
        
        
        
        
        goalTimePeriodStartDatePicker.datePickerMode = .date
        goalTimePeriodToDateLabel.text = "到"
        goalTimePeriodToDateLabel.font = AppConfig.Font.title.value
        goalTimePeriodToDateLabel.textAlignment = .center
        goalTimePeriodEndDatePicker.datePickerMode = .date
//        goalTimePeriodEndDatePicker.minimumDate = .now
        
        goalTimePeriodInfiniteReplaceDatePickerLabel.text = "很久以後"
        goalTimePeriodInfiniteReplaceDatePickerLabel.font = AppConfig.Font.tertiaryTitle.value
        goalTimePeriodInfiniteReplaceDatePickerLabel.isHidden = true
        goalTimePeriodInfiniteReplaceDatePickerLabel.textAlignment = .right
        
        
        goalTimePeriodDatePickerStackView = UIStackView(arrangedSubviews: [goalTimePeriodStartDatePicker, goalTimePeriodToDateLabel, goalTimePeriodEndDatePicker, goalTimePeriodInfiniteReplaceDatePickerLabel])
        goalTimePeriodStackView?.axis = .horizontal
        goalTimePeriodDatePickerStackView?.spacing = 5
        goalTimePeriodDatePickerStackView?.distribution = .fillEqually
        goalTimePeriodDatePickerStackView?.alignment = .center
        
        
        
        goalTimePeriodStackView = UIStackView(arrangedSubviews: [goalTimePeriodLabelAndSwitchStackView!, goalTimePeriodDatePickerStackView!])
        goalTimePeriodStackView?.axis = .vertical
        goalTimePeriodStackView?.spacing = 8
        
        
//        isPeriodGoalLabel.text = "是否為週期性目標"
//        isPeriodGoalLabel.font = AppConfig.Font.title.value
//        
//        isPeriodGoalStackView = UIStackView(arrangedSubviews: [isPeriodGoalLabel, isPeriodGoalSegmentedControl])
//        isPeriodGoalStackView?.axis = .vertical
//        isPeriodGoalStackView?.spacing = 8
        
        
        wholePageStackView = UIStackView(arrangedSubviews: [goalNameStackView!, goalAmountStackView!, goalTimePeriodStackView!])
        wholePageStackView?.axis = .vertical
        wholePageStackView?.spacing = 15
        wholePageStackView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wholePageStackView!)
        wholePageStackView?.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        wholePageStackView?.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        wholePageStackView?.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
    }
}

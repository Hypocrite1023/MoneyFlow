//
//  SettingExpenseGoalView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/2.
//

import UIKit

class SettingExpenseGoalView: UIView {
    private let vstack: UIStackView = UIStackView()
    
    private let dailyExpenseLabel: UILabel = UILabel()
    let dailyExpenseTextField: UITextField = UITextField()
    
    private let weeklyExpenseLabel: UILabel = UILabel()
    let weeklyExpenseTextField: UITextField = UITextField()
    
    private let monthlyExpenseLabel: UILabel = UILabel()
    let monthlyExpenseTextField: UITextField = UITextField()
    
    private let actionButtonHstack: UIStackView = UIStackView()
    let saveButton: UIButton = UIButton(configuration: .tinted())
    let cancelButton: UIButton = UIButton(configuration: .tinted())

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        setView()
        addView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        vstack.axis = .vertical
        vstack.spacing = 10
        
        dailyExpenseLabel.text = NSLocalizedString("SettingExpenseGoalView_DailyExpenseLabel_Title", comment: "")
        dailyExpenseLabel.font = AppConfig.Font.tertiaryTitle.value
        
        dailyExpenseTextField.borderStyle = .roundedRect
        dailyExpenseTextField.keyboardType = .decimalPad
        
        weeklyExpenseLabel.text = NSLocalizedString("SettingExpenseGoalView_WeeklyExpenseLabel_Title", comment: "")
        weeklyExpenseLabel.font = AppConfig.Font.tertiaryTitle.value
        
        weeklyExpenseTextField.borderStyle = .roundedRect
        weeklyExpenseTextField.keyboardType = .decimalPad
        
        monthlyExpenseLabel.text = NSLocalizedString("SettingExpenseGoalView_MonthlyExpenseLabel_Title", comment: "")
        monthlyExpenseLabel.font = AppConfig.Font.tertiaryTitle.value
        
        monthlyExpenseTextField.borderStyle = .roundedRect
        monthlyExpenseTextField.keyboardType = .decimalPad
        
        actionButtonHstack.axis = .horizontal
        actionButtonHstack.spacing = 10
        
        saveButton.tintColor = .systemBlue
        saveButton.setTitle(NSLocalizedString("SettingExpenseGoalView_SaveButton_Title", comment: ""), for: .normal)
        
        cancelButton.tintColor = .systemRed
        cancelButton.setTitle(NSLocalizedString("SettingExpenseGoalView_CancelButton_Title", comment: ""), for: .normal)
    }
    
    private func addView() {
        addSubview(vstack)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        [dailyExpenseLabel, dailyExpenseTextField, weeklyExpenseLabel, weeklyExpenseTextField, monthlyExpenseLabel, monthlyExpenseTextField].forEach { view in
            vstack.addArrangedSubview(view)
        }
        
        addSubview(actionButtonHstack)
        actionButtonHstack.translatesAutoresizingMaskIntoConstraints = false
        actionButtonHstack.addArrangedSubview(cancelButton)
        actionButtonHstack.addArrangedSubview(saveButton)
    }
    
    private func setConstraints() {
        vstack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        vstack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        vstack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        vstack.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        actionButtonHstack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        actionButtonHstack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}

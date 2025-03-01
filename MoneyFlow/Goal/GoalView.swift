//
//  GoalView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/17.
//

import UIKit

class GoalView: UIView {
    
    private let upperView: UIView = UIView()
    private let lowerView: UIView = UIView()

    private let savingGoalTitleLabel: UILabel = createLabel(title: "儲蓄目標")
    let addGoalButton: UIButton = UIButton(configuration: .tinted())
    
    let savingGoalPreviewTableView: UITableView = UITableView()
    let noSavingGoalLabel: UILabel = {
        let label = UILabel()
        label.text = "尚未建立儲蓄目標"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expenseGoalTitleLabel: UILabel = createLabel(title: "花費限制目標")
    let dailyExpenseGoal: UnitGoalPreview = UnitGoalPreview()
    let weeklyExpenseGoal: UnitGoalPreview = UnitGoalPreview()
    let monthlyExpenseGoal: UnitGoalPreview = UnitGoalPreview()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupUpperView()
        setupLowerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        self.addSubview(upperView)
        self.addSubview(lowerView)
        
        upperView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        upperView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        upperView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        upperView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        lowerView.topAnchor.constraint(equalTo: upperView.bottomAnchor).isActive = true
        lowerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        lowerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        lowerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
    }
    
    private func setupUpperView() {
        upperView.addSubview(savingGoalTitleLabel)
        savingGoalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        savingGoalTitleLabel.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        savingGoalTitleLabel.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 10).isActive = true
//        goalTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        
        addGoalButton.translatesAutoresizingMaskIntoConstraints = false
        addGoalButton.setTitle("新增目標", for: .normal)
        addGoalButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addGoalButton.tintColor = .black
        upperView.addSubview(addGoalButton)
        addGoalButton.leadingAnchor.constraint(greaterThanOrEqualTo: savingGoalTitleLabel.trailingAnchor).isActive = true
        addGoalButton.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        addGoalButton.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 10).isActive = true
        addGoalButton.heightAnchor.constraint(equalTo: savingGoalTitleLabel.heightAnchor).isActive = true
        
        savingGoalPreviewTableView.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(savingGoalPreviewTableView)
        savingGoalPreviewTableView.topAnchor.constraint(equalTo: addGoalButton.bottomAnchor, constant: 10).isActive = true
        savingGoalPreviewTableView.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        savingGoalPreviewTableView.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        savingGoalPreviewTableView.bottomAnchor.constraint(equalTo: upperView.bottomAnchor).isActive = true
        savingGoalPreviewTableView.backgroundView = noSavingGoalLabel
        noSavingGoalLabel.centerXAnchor.constraint(equalTo: savingGoalPreviewTableView.centerXAnchor).isActive = true
        noSavingGoalLabel.centerYAnchor.constraint(equalTo: savingGoalPreviewTableView.centerYAnchor).isActive = true
    }
    
    private func setupLowerView() {
        lowerView.addSubview(expenseGoalTitleLabel)
        expenseGoalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        expenseGoalTitleLabel.topAnchor.constraint(equalTo: lowerView.topAnchor, constant: 10).isActive = true
        expenseGoalTitleLabel.leadingAnchor.constraint(equalTo: lowerView.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        
        let vstack = UIStackView(arrangedSubviews: [dailyExpenseGoal, weeklyExpenseGoal, monthlyExpenseGoal])
        vstack.axis = .vertical
        vstack.spacing = 10
        vstack.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(vstack)
        vstack.topAnchor.constraint(equalTo: expenseGoalTitleLabel.bottomAnchor, constant: 10).isActive = true
        vstack.leadingAnchor.constraint(equalTo: lowerView.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        vstack.trailingAnchor.constraint(equalTo: lowerView.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        vstack.bottomAnchor.constraint(equalTo: lowerView.bottomAnchor, constant: -15).isActive = true
        
    }
    
    private static func createLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = AppConfig.Font.title.value
        return label
    }
}

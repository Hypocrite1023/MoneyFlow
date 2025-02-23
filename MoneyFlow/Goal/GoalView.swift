//
//  GoalView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/17.
//

import UIKit

class GoalView: UIView {

    private let goalTitleLabel: UILabel = createLabel(title: "目標")
    let addGoalButton: UIButton = UIButton(configuration: .tinted())
    
    let goalPreviewTableView: UITableView = UITableView()
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "尚未建立目標"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        self.addSubview(goalTitleLabel)
        goalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        goalTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        goalTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
//        goalTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        
        addGoalButton.translatesAutoresizingMaskIntoConstraints = false
        addGoalButton.setTitle("新增目標", for: .normal)
        addGoalButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addGoalButton.tintColor = .black
        addSubview(addGoalButton)
        addGoalButton.leadingAnchor.constraint(greaterThanOrEqualTo: goalTitleLabel.trailingAnchor).isActive = true
        addGoalButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        addGoalButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        addGoalButton.heightAnchor.constraint(equalTo: goalTitleLabel.heightAnchor).isActive = true
        
        goalPreviewTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(goalPreviewTableView)
        goalPreviewTableView.topAnchor.constraint(equalTo: addGoalButton.bottomAnchor, constant: 15).isActive = true
        goalPreviewTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        goalPreviewTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        goalPreviewTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        goalPreviewTableView.backgroundView = noDataLabel
        noDataLabel.centerXAnchor.constraint(equalTo: goalPreviewTableView.centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: goalPreviewTableView.centerYAnchor).isActive = true
    }
    
    private static func createLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = AppConfig.Font.title.value
        return label
    }
}

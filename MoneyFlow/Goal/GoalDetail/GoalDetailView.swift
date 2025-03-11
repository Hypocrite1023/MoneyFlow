//
//  GoalDetailView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/27.
//

import UIKit

class GoalDetailView: UIView {
    
    // goal duration
    // goal progress
    // relation transaction table view
    private let goalDurationLabel: UILabel = UILabel()
    let progressView: CircularProgressView = CircularProgressView()
    private let relationTransactionTitleLabel: UILabel = UILabel()
    let relationTransacitonTableView: UITableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        self.backgroundColor = .white
        setupGoalDurationLabel()
        setupProgressView()
        setupRelationTransactionTitleLabel()
        setupRelationTransactionTableView()
    }
    
    private func setupGoalDurationLabel() {
        addSubview(goalDurationLabel)
        goalDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        goalDurationLabel.font = AppConfig.Font.tertiaryTitle.value
        goalDurationLabel.textAlignment = .center
        
        goalDurationLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        goalDurationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        goalDurationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
    }
    
    private func setupProgressView() {
        addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        progressView.topAnchor.constraint(equalTo: goalDurationLabel.bottomAnchor, constant: 10).isActive = true
        progressView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setupRelationTransactionTitleLabel() {
        addSubview(relationTransactionTitleLabel)
        relationTransactionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        relationTransactionTitleLabel.text = NSLocalizedString("GoalDetailView_RelationTransactionTitleLabel_Title", comment: "")
        relationTransactionTitleLabel.font = AppConfig.Font.title.value
        
        relationTransactionTitleLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10).isActive = true
        relationTransactionTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        relationTransactionTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
    }
    
    private func setupRelationTransactionTableView() {
        addSubview(relationTransacitonTableView)
        relationTransacitonTableView.translatesAutoresizingMaskIntoConstraints = false
        relationTransacitonTableView.topAnchor.constraint(equalTo: relationTransactionTitleLabel.bottomAnchor, constant: 10).isActive = true
        relationTransacitonTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        relationTransacitonTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        relationTransacitonTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    func setGoalDuration(startDate: Date, endDate: Date?) {
        goalDurationLabel.text = "\(AppFormatter.shared.dateFormatter.string(from: startDate)) ~ \(endDate == nil ? NSLocalizedString("GoalDetailView_GoalDurationLabel_Infinity_Title", comment: "") : AppFormatter.shared.dateFormatter.string(from: endDate!))"
    }
}

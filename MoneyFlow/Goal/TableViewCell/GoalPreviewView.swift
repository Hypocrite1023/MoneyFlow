//
//  GoalPreviewView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/19.
//

import UIKit

class GoalPreviewView: UITableViewCell {

    private let goalNameLabel: UILabel = UILabel()
    private let goalProgressView: UIProgressView = UIProgressView()
    private let nowAmountLabel: UILabel = UILabel()
    private let divideLabel: UILabel = UILabel()
    private let goalAmountLabel: UILabel = UILabel()
    private var amountHStack: UIStackView?
    private var vstack: UIStackView?
    var goalUUID: UUID?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
//        goalNameLabel.text = goalName
        goalNameLabel.font = AppConfig.Font.secondaryTitle.value
        goalNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        goalProgressView.layer.borderWidth = 1
//        goalProgressView.layer.borderColor = UIColor.red.cgColor
        
        nowAmountLabel.textColor = .secondaryLabel
        nowAmountLabel.font = .systemFont(ofSize: 12, weight: .light)
        nowAmountLabel.textAlignment = .right
        
        divideLabel.text = "/"
        divideLabel.textColor = .secondaryLabel
        divideLabel.font = .systemFont(ofSize: 12, weight: .light)
        
//        goalAmountLabel.text = String(format: "%.1f", goalAmount)
        goalAmountLabel.textColor = .secondaryLabel
        goalAmountLabel.font = .systemFont(ofSize: 12, weight: .light)
        goalAmountLabel.textAlignment = .right
        
        amountHStack = UIStackView(arrangedSubviews: [nowAmountLabel, divideLabel, goalAmountLabel])
        amountHStack?.axis = .horizontal
        amountHStack?.spacing = 3
        amountHStack?.distribution = .fill
//        amountHStack?.layer.borderWidth = 1
//        amountHStack?.layer.borderColor = UIColor.green.cgColor
        
        vstack = UIStackView(arrangedSubviews: [goalProgressView , amountHStack!])
        vstack?.axis = .vertical
//        vstack?.alignment = .trailing
        vstack?.spacing = 1
        vstack?.distribution = .fillProportionally
        vstack?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(goalNameLabel)
        addSubview(vstack!)
        
        goalNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        goalNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        vstack?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        vstack?.topAnchor.constraint(equalTo: topAnchor , constant: 8).isActive = true
        vstack?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        vstack?.leadingAnchor.constraint(lessThanOrEqualTo: centerXAnchor).isActive = true
        
        self.layer.cornerRadius = 8
        backgroundColor = .systemGray6
        
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setGoalName(goalName: String) {
        goalNameLabel.text = goalName
    }
    
    func setNowAmount(nowAmount: Double) {
        nowAmountLabel.text = "\(nowAmount)"
    }
    
    func setGoalAmount(goalAmount: Double) {
        goalAmountLabel.text = String(format: "%.1f", goalAmount)
    }
    
    func setGoalProgressView(progress: Double) {
        goalProgressView.setProgress(Float(progress), animated: true)
    }
}

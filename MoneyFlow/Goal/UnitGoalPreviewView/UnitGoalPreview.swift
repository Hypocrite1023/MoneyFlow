//
//  UnitGoalPreview.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/1.
//

import UIKit

class UnitGoalPreview: UIView {

    private let goalNameLabel: UILabel = UILabel()
    private let goalProgressView: UIProgressView = UIProgressView()
    let nowAmountLabel: UILabel = UILabel()
    private let divideLabel: UILabel = UILabel()
    let goalAmountLabel: UILabel = UILabel()
    private var amountHStack: UIStackView?
    private var vstack: UIStackView?
    
    private let goalNotSettingLabel: UILabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        goalNameLabel.font = AppConfig.Font.tertiaryTitle.value
        goalNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nowAmountLabel.textColor = .secondaryLabel
        nowAmountLabel.font = .systemFont(ofSize: 12, weight: .light)
        nowAmountLabel.textAlignment = .right
        
        divideLabel.text = "/"
        divideLabel.textColor = .secondaryLabel
        divideLabel.font = .systemFont(ofSize: 12, weight: .light)
        divideLabel.textAlignment = .right
        
        goalAmountLabel.textColor = .secondaryLabel
        goalAmountLabel.font = .systemFont(ofSize: 12, weight: .light)
        goalAmountLabel.textAlignment = .right
        
        let flexView: UIView = UIView()
        flexView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        amountHStack = UIStackView(arrangedSubviews: [flexView, nowAmountLabel, divideLabel, goalAmountLabel])
        amountHStack?.axis = .horizontal
        amountHStack?.spacing = 3
        amountHStack?.distribution = .fill
        
        vstack = UIStackView(arrangedSubviews: [goalProgressView , amountHStack!])
        vstack?.axis = .vertical
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
        
        goalNotSettingLabel.text = NSLocalizedString("GoalView_UnitGoalPreview_GoalNotSettingLabel_Title", comment: "")
        goalNotSettingLabel.font = AppConfig.Font.content.value
        goalNotSettingLabel.textColor = .secondaryLabel
        goalNotSettingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(goalNotSettingLabel)
        
        goalNotSettingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        goalNotSettingLabel.topAnchor.constraint(equalTo: topAnchor , constant: 8).isActive = true
        goalNotSettingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        goalNotSettingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: centerXAnchor).isActive = true
        
        self.layer.cornerRadius = 8
        backgroundColor = .systemGray6
        
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setGoalName(goalName: String) {
        goalNameLabel.text = goalName
    }
    
    func setNowAmount(nowAmount: Double) {
        nowAmountLabel.text = String(format: "%.1f", nowAmount)
    }
    
    func setGoalAmount(goalAmount: Double?) {
        guard let goalAmount else {
            vstack?.arrangedSubviews.forEach({$0.isHidden = true})
            goalNotSettingLabel.isHidden = false
            return
        }
        guard !(goalAmount == 0.0) else {
            vstack?.arrangedSubviews.forEach({$0.isHidden = true})
            goalNotSettingLabel.isHidden = false
            return
        }
        vstack?.arrangedSubviews.forEach({$0.isHidden = false})
        goalNotSettingLabel.isHidden = true
        goalAmountLabel.text = AppFormatter.shared.currencyNumberFormatter.string(from: goalAmount as NSNumber)
    }
    
    func setGoalProgressView(progress: Double) {
        if progress >= 1 {
            goalProgressView.setProgress(1.0, animated: true)
            goalProgressView.progressTintColor = .systemRed
        }
        else if progress >= 0.8 {
            goalProgressView.setProgress(Float(progress), animated: true)
            goalProgressView.progressTintColor = .systemOrange
        } else if progress >= 0.5 {
            goalProgressView.setProgress(Float(progress), animated: true)
            goalProgressView.progressTintColor = .systemYellow
        } else {
            goalProgressView.setProgress(Float(progress), animated: true)
            goalProgressView.progressTintColor = .systemGreen
        }
    }
    
}

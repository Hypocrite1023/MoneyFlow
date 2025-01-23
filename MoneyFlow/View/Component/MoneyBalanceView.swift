//
//  MoneyBalanceView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/21.
//

import UIKit

class MoneyBalanceView: UIView {
    
    private var labelVerticalStack: UIStackView = UIStackView()
    private var itemLabel: UILabel = UILabel()
    private var balanceLabel: UILabel = UILabel()
    
    init(itemLabelText: String, balance: Int) {
        super.init(frame: .zero)
        setupView(itemLabelText: itemLabelText, balance: balance)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(itemLabelText: String, balance: Int) {
        // label vertical stack
        self.addSubview(labelVerticalStack)
        labelVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        labelVerticalStack.axis = .vertical
        labelVerticalStack.spacing = 5
        labelVerticalStack.distribution = .fill
        labelVerticalStack.addArrangedSubview(itemLabel)
        labelVerticalStack.addArrangedSubview(balanceLabel)
        
        // item label
        itemLabel.text = itemLabelText
        itemLabel.textColor = .darkGray
        itemLabel.textAlignment = .left
        itemLabel.font = UIFont.systemFont(ofSize: 17)
        
        // balance label
        balanceLabel.textAlignment = .left
        balanceLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        balanceLabel.text = AppNumberFormatter.shared.currencyNumberFormatter.string(from: NSNumber(value: balance)) ?? ""
        
        labelVerticalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        labelVerticalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        labelVerticalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        labelVerticalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
        self.layer.borderColor = UIColor.systemGray3.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    
}

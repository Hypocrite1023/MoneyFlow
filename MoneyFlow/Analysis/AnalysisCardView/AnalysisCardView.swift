//
//  AnalysisCardView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/6.
//

import UIKit

/*
 📌 統計卡片
     1.    本月總支出（金額 + 與上月比較%）
     2.    本月總收入（金額 + 與上月比較%）
     3.    本月結餘（收入 - 支出）（綠色：盈餘、紅色：虧損）
 */

class AnalysisCardView: UIView {

    private let titleLabel: UILabel = UILabel()
    private let amountLabel: UILabel = UILabel()
    private let compareLabel: UILabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setView()
        addView()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        amountLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        compareLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    private func addView() {
        [titleLabel, amountLabel, compareLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    private func setupConstraints() {
        let layoutConstraints: [NSLayoutConstraint] = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            
            amountLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 15),
            amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            compareLabel.leadingAnchor.constraint(greaterThanOrEqualTo: amountLabel.trailingAnchor, constant: 30),
            compareLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            compareLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            compareLabel.topAnchor.constraint(equalTo: amountLabel.topAnchor),
            
            self.widthAnchor.constraint(equalToConstant: 200),
            self.heightAnchor.constraint(equalToConstant: 100),
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func setupValues(title: String, amount: Double, compare: String) {
        titleLabel.text = title
        amountLabel.text = AppFormatter.shared.currencyNumberFormatter.string(from: NSNumber(value: amount))
        compareLabel.text = compare
    }
    
}

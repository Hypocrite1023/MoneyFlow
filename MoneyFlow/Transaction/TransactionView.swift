//
//  TransactionDetailView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/14.
//

import UIKit

class TransactionView: UIView {
    
    var transactionTableView: UITableView = UITableView()
    private let transactionDetailLabel: UILabel = createLabel(title: "紀錄")
    var transactionFilterButton: UIButton = UIButton(configuration: .plain())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
        setTransactionTitle()
        setTransactionFilterButton()
        setTransactionTableView()
    }
    
    private func setTransactionTitle() {
        transactionDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(transactionDetailLabel)
        transactionDetailLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        transactionDetailLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
    }
    
    private func setTransactionFilterButton() {
        transactionFilterButton.translatesAutoresizingMaskIntoConstraints = false
        transactionFilterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        transactionFilterButton.setTitle("篩選", for: .normal)
        addSubview(transactionFilterButton)
        transactionFilterButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        transactionFilterButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
    }
    
    private func setTransactionTableView() {
        addSubview(transactionTableView)
        transactionTableView.translatesAutoresizingMaskIntoConstraints = false
        transactionTableView.topAnchor.constraint(equalTo: transactionDetailLabel.bottomAnchor, constant: 10).isActive = true
        transactionTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        transactionTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        transactionTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private static func createLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = AppConfig.Font.title.value
        return label
    }

}

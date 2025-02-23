//
//  TransactionDetailView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/14.
//

import UIKit

class TransactionDetailView: UIView {
    
    private var transactionDetailViewScrollView: UIScrollView = UIScrollView()
    private var transactionStackView: UIStackView = UIStackView()
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
        setupScrollView()
        setupTransactionStackView()
    }
    
    private func setTransactionTitle() {
        transactionDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(transactionDetailLabel)
        transactionDetailLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
//        transactionDetailLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
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
    
    private func setupScrollView() {
        transactionDetailViewScrollView.translatesAutoresizingMaskIntoConstraints = false
        transactionDetailViewScrollView.showsVerticalScrollIndicator = false
        transactionDetailViewScrollView.showsHorizontalScrollIndicator = false
//        transactionDetailViewScrollView.layer.borderWidth = 1
//        transactionDetailViewScrollView.layer.borderColor = UIColor.red.cgColor
        addSubview(transactionDetailViewScrollView)
        
        transactionDetailViewScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        transactionDetailViewScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        transactionDetailViewScrollView.topAnchor.constraint(equalTo: transactionDetailLabel.bottomAnchor, constant: 20).isActive = true
        transactionDetailViewScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupTransactionStackView() {
        transactionStackView.axis = .vertical
        transactionStackView.translatesAutoresizingMaskIntoConstraints = false
        transactionDetailViewScrollView.addSubview(transactionStackView)
        transactionStackView.leadingAnchor.constraint(equalTo: transactionDetailViewScrollView.leadingAnchor).isActive = true
        transactionStackView.trailingAnchor.constraint(equalTo: transactionDetailViewScrollView.trailingAnchor).isActive = true
        transactionStackView.topAnchor.constraint(equalTo: transactionDetailViewScrollView.topAnchor).isActive = true
        transactionStackView.bottomAnchor.constraint(equalTo: transactionDetailViewScrollView.bottomAnchor).isActive = true
        transactionStackView.widthAnchor.constraint(equalTo: transactionDetailViewScrollView.widthAnchor).isActive = true
    }
    
    func updateTransactionStack(transactions: [Transaction]?) {
        transactionStackView.subviews.forEach { $0.removeFromSuperview() }
        if let transactions {
            var currentDate: (Int, Int, Int) = (0, 0, 0)// year, month, day
            for transaction in transactions {
                let transactionItemView = TransactionItemView(itemName: transaction.itemName, itemCategory: AccountingTransactionCategory(rawValue: transaction.category)!, itemValue: transaction.amount)
                
                let transactionYear = Calendar.current.component(.year, from: transaction.date)
                let transactionMonth = Calendar.current.component(.month, from: transaction.date)
                let transactionDay = Calendar.current.component(.day, from: transaction.date)
                if currentDate != (transactionYear, transactionMonth, transactionDay) {
                    currentDate = (transactionYear, transactionMonth, transactionDay)
                    let dateLabel = UILabel()
                    dateLabel.text = "\(transactionYear)/\(transactionMonth)/\(transactionDay)"
                    dateLabel.font = AppConfig.Font.secondaryTitle.value
                    transactionStackView.addArrangedSubview(dateLabel)
                }
                
                transactionStackView.addArrangedSubview(transactionItemView)
                
                
            }
        }
        
    }
    
    private static func createLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = AppConfig.Font.title.value
        return label
    }

}

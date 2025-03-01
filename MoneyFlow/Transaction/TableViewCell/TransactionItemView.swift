//
//  TransactionItemView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/21.
//

import UIKit

class TransactionItemView: UITableViewCell {
    
    private var categoryImageView: UIImageView = UIImageView()
    private var itemCategoryLabel: UILabel = UILabel()
    private var itemDescriptionLabel: UILabel = UILabel()
    private var itemValueLabel: UILabel = UILabel()
    private var dividerLine: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setCategoryImageView()
        setItemNameLabel()
        setItemDescriptionLabel()
        setItemValueLabel()
        setDivider()
    }
    
    private func setCategoryImageView() {
        categoryImageView.tintColor = .darkGray
        
        categoryImageView.layer.cornerRadius = 20
        categoryImageView.clipsToBounds = true
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(categoryImageView)
        categoryImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        categoryImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        categoryImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        categoryImageView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 15).isActive = true
        categoryImageView.bottomAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: -15).isActive = true
        categoryImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setItemNameLabel() {
        
        itemCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(itemCategoryLabel)
        
        itemCategoryLabel.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 15).isActive = true
        itemCategoryLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 5).isActive = true
    }
    
    private func setItemDescriptionLabel() {
        itemDescriptionLabel.textColor = .systemGray
        
        self.addSubview(itemDescriptionLabel)
        itemDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        itemDescriptionLabel.topAnchor.constraint(lessThanOrEqualTo: itemCategoryLabel.bottomAnchor, constant: 5).isActive = true
        itemDescriptionLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 5).isActive = true
        itemDescriptionLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: -15).isActive = true
    }
    
    private func setItemValueLabel() {
        itemValueLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        self.addSubview(itemValueLabel)
        itemValueLabel.translatesAutoresizingMaskIntoConstraints = false
        itemValueLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        itemValueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        itemValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setDivider() {
        dividerLine.backgroundColor = .systemGray5
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dividerLine)
        
        dividerLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    func setUpCell(with transaction: Transaction) {
        itemValueLabel.text = "\(transaction.type == "支出" ? "" : "+")\(AppFormatter.shared.currencyNumberFormatter.string(from: NSNumber(value: transaction.type == "支出" ? -transaction.amount : transaction.amount))!)" 
        itemCategoryLabel.text = transaction.category
        categoryImageView.image = UIImage(systemName: AccountingTransactionCategory(rawValue: transaction.category)?.imageName ?? "photo")
        itemDescriptionLabel.text = transaction.itemName
    }
}

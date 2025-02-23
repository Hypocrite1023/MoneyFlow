//
//  TransactionItemView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/21.
//

import UIKit

class TransactionItemView: UIView {
    
    private var categoryImageView: UIImageView?
    private var itemCategoryLabel: UILabel?
    private var itemDescriptionLabel: UILabel?
    private var itemValueLabel: UILabel?
    private var dividerLine: UIView?
    
    init(itemName: String, itemCategory: AccountingTransactionCategory, itemValue: Double) {
        super.init(frame: .zero)
        setupViews(itemName: itemName, itemCategory: itemCategory, itemValue: itemValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(itemName: String, itemCategory: AccountingTransactionCategory, itemValue: Double) {
        setCategoryImageView(itemCategory: itemCategory)
        setItemNameLabel(itemCategory: itemCategory)
        setItemDescriptionLabel(itemName: itemName)
        setItemValueLabel(itemValue: itemValue)
        setDivider()
    }
    
    private func setCategoryImageView(itemCategory: AccountingTransactionCategory) {
        categoryImageView = UIImageView(image: UIImage(systemName: itemCategory.imageName))
        categoryImageView?.tintColor = .darkGray
        guard let categoryImageView else { return }
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
    
    private func setItemNameLabel(itemCategory: AccountingTransactionCategory) {
        itemCategoryLabel = UILabel()
        guard let itemCategoryLabel else { return }
        itemCategoryLabel.text = itemCategory.rawValue
        itemCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(itemCategoryLabel)
        
        itemCategoryLabel.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 15).isActive = true
        itemCategoryLabel.leadingAnchor.constraint(equalTo: categoryImageView!.trailingAnchor, constant: 5).isActive = true
    }
    
    private func setItemDescriptionLabel(itemName: String) {
        itemDescriptionLabel = UILabel()
        guard let itemDescriptionLabel else { return }
        itemDescriptionLabel.text = itemName
        itemDescriptionLabel.textColor = .systemGray
        
        self.addSubview(itemDescriptionLabel)
        itemDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        itemDescriptionLabel.topAnchor.constraint(lessThanOrEqualTo: itemCategoryLabel!.bottomAnchor, constant: 5).isActive = true
        itemDescriptionLabel.leadingAnchor.constraint(equalTo: categoryImageView!.trailingAnchor, constant: 5).isActive = true
        itemDescriptionLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: -15).isActive = true
    }
    
    private func setItemValueLabel(itemValue: Double) {
        itemValueLabel = UILabel()
        guard let itemValueLabel else { return }
        itemValueLabel.text = "$\(itemValue)"
        itemValueLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        self.addSubview(itemValueLabel)
        itemValueLabel.translatesAutoresizingMaskIntoConstraints = false
        itemValueLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        itemValueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        itemValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setDivider() {
        dividerLine = UIView()
        guard let dividerLine else { return }
        dividerLine.backgroundColor = .systemGray5
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dividerLine)
        
        dividerLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
}

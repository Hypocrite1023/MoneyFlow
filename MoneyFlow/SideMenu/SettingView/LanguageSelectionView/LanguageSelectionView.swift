//
//  LanguageSelectionView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/10.
//

import UIKit

class LanguageSelectionView: UIView {

    let settingTableView: UITableView = UITableView()
    var settingTableViewHeightConstraint: NSLayoutConstraint!
    
    init() {
        super.init(frame: .zero)
        setView()
        addSubviews()
        setConstraints()
        backgroundColor = .systemGray5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        settingTableView.layer.cornerRadius = 10
        settingTableView.clipsToBounds = true
        
        settingTableView.isScrollEnabled = false // 禁止滾動，讓它依據內容調整大小
    }
    
    private func addSubviews() {
        [settingTableView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            settingTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            settingTableView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: -20),
            settingTableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        settingTableViewHeightConstraint = settingTableView.heightAnchor.constraint(equalToConstant: 0)
        settingTableViewHeightConstraint.isActive = true
    }
    
    func updateSettingTableViewHeight() {
        settingTableViewHeightConstraint.constant = settingTableView.contentSize.height
    }

}

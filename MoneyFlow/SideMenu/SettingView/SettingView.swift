//
//  SettingView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/10.
//

import UIKit

class SettingView: UIView {

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
        settingTableView.isScrollEnabled = false
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
//            settingTableView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        settingTableViewHeightConstraint = settingTableView.heightAnchor.constraint(equalToConstant: 0)
        settingTableViewHeightConstraint.isActive = true
    }
    
    func updateSettingTableViewHeightConstraint() {
        settingTableViewHeightConstraint.constant = settingTableView.contentSize.height
    }
    
}

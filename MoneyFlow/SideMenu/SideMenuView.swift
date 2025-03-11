//
//  SideMenuView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/10.
//

import UIKit

class SideMenuView: UIView {

    let appSettingButton: UIButton = UIButton(configuration: .tinted())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        self.addSubview(blurView)
        setView()
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        appSettingButton.setTitle(NSLocalizedString("SideMenu_AppSetting_Title", comment: ""), for: .normal)
        appSettingButton.tintColor = .black
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            appSettingButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            appSettingButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            appSettingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    private func addSubviews() {
        [appSettingButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        self.addSubview(appSettingButton)
    }
}

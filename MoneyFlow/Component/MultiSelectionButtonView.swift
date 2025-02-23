//
//  MultipleSelectionButtonView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/26.
//

import UIKit

class MultiSelectionButtonView: SingleSelectionButtonView {
    
    override func setView() {
        print(selectionList)
        if let mayNil, mayNil && selectionList == nil {
            let addTagLabel = UILabel()
            addTagLabel.text = "尚未設定任何標籤"
            addTagLabel.textColor = .secondaryLabel
            addTagLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(addTagLabel)
            addTagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            addTagLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            addTagLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            addTagLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            return
        }
        super.setView()
    }

    override func updateButtonStatus() {
        for button in buttonList {
            if selected.contains(button.title(for: .normal)!) {
                button.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
            } else {
                button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
            }
        }
    }
    
    override func buttonAction(_ sender: UIButton) {
        if selected.contains(sender.title(for: .normal)!) {
            selected.remove(sender.title(for: .normal)!)
        } else {
            selected.insert(sender.title(for: .normal)!)
        }
        updateButtonStatus()
    }
    
    func refreshTags() {
        self.selectionList = Array(AccountingTagManager.shared.getTags()!)
    }
}

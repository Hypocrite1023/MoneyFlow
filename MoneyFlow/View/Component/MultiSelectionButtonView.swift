//
//  MultipleSelectionButtonView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/26.
//

import UIKit

class MultiSelectionButtonView: SingleSelectionButtonView {

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

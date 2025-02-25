//
//  MultipleSelectionButtonView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/26.
//

import UIKit

class MultiSelectionView: SelectionView, ObservableObject {
    
    let mayNil: Bool
    let selectionListNilPrompt: String
    @Published var selectedIndex: Set<Int> = []
    
    init(selectionList: [String], mayNil: Bool = false, selectionListNilPrompt: String = "尚未有任何選項", preselectIndex: Set<Int> = []) {
        self.mayNil = mayNil
        self.selectedIndex = preselectIndex
        self.selectionListNilPrompt = selectionListNilPrompt
        super.init(selectionList: selectionList)
        if preselectIndex != [] {
            updateButtonStatus()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setView() {
        ifselectionListNilSetPrompt()
        super.setView()
        for button in buttonList {
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
    }

    func updateButtonStatus() {
        for (index, button) in buttonList.enumerated() {
            if selectedIndex.contains(index) {
                button.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
            } else {
                button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
            }
        }
    }
    
    internal func updateSelectionList(list: [String]) {
        self.selectionList = list
        horizonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        setView()
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        if selectedIndex.contains(sender.tag) {
            selectedIndex.remove(sender.tag)
        } else {
            selectedIndex.insert(sender.tag)
        }
        updateButtonStatus()
    }
    
    private func ifselectionListNilSetPrompt() {
        if mayNil == true && selectionList == [] {
            let promptLabel = UILabel()
            promptLabel.text = selectionListNilPrompt
            promptLabel.textColor = .secondaryLabel
            promptLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(promptLabel)
            promptLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            promptLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            promptLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            promptLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            return
        }
    }
    
    func refreshTags() {
        self.selectionList = Array(AccountingTagManager.shared.getTags()!)
    }
}

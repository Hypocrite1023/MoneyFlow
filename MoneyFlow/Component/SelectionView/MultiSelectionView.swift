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
    let promptLabel: UILabel = UILabel()
    @Published var selectedIndex: Set<String> = [] {
        didSet {
            if selectedIndex != [] {
                updateButtonStatus()
            }
        }
    }
    
    init(selectionList: [String], mayNil: Bool = false, selectionListNilPrompt: String = "尚未有任何選項", preselectIndex: Set<String> = []) {
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
        ifSelectionListNilSetPrompt()
        super.setView()
        for button in buttonList {
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
    }

    func updateButtonStatus() {
        for (_, button) in buttonList.enumerated() {
            if selectedIndex.contains(button.title(for: .normal)!) {
                button.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
            } else {
                button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
            }
        }
    }
    
    internal func updateSelectionList(list: [String]) {
        promptLabel.removeFromSuperview()
        self.selectionList = list
        horizonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        setView()
        updateButtonStatus()
        checkSelected()
        print(selectionList)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        if selectedIndex.contains(sender.title(for: .normal)!) {
            selectedIndex.remove(sender.title(for: .normal)!)
        } else {
            selectedIndex.insert(sender.title(for: .normal)!)
        }
        updateButtonStatus()
    }
    
    private func ifSelectionListNilSetPrompt() {
        if mayNil == true && selectionList == [] {
            print("nil")
            promptLabel.text = selectionListNilPrompt
            promptLabel.textColor = .secondaryLabel
            promptLabel.translatesAutoresizingMaskIntoConstraints = false
            horizonScrollView.addSubview(promptLabel)
            promptLabel.leadingAnchor.constraint(equalTo: horizonScrollView.leadingAnchor).isActive = true
            promptLabel.trailingAnchor.constraint(equalTo: horizonScrollView.trailingAnchor).isActive = true
            promptLabel.topAnchor.constraint(equalTo: horizonScrollView.topAnchor).isActive = true
            promptLabel.bottomAnchor.constraint(equalTo: horizonScrollView.bottomAnchor).isActive = true
        }
    }
    
    private func checkSelected() {
        for select in selectedIndex {
            if selectionList.contains(select) == false {
                selectedIndex.remove(select)
            }
        }
    }
    
    func refreshTags() {
        self.selectionList = Array(AccountingTagManager.shared.getTags()!)
    }
}

//
//  SingleSelectionViewWithResult.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/26.
//

import UIKit
import Combine

class SingleSelectionExpandable: SelectionViewExpandable, ObservableObject {
    
    @Published var selected: UUID?
    private var initialButton: UIButton?
    
    override init(height: CGFloat = 30, width: CGFloat = 60, spacing: CGFloat = 10) {
        super.init(height: height, width: width, spacing: spacing)
//        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        
        if let selected {
            let button = UIButton(configuration: .plain())
            var conf = button.configuration
            conf?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            button.setTitle(NSLocalizedString((selectionList.first(where: { (uuid: UUID, locolizedKey: String) -> Bool in
                selected == uuid
            })?.locolizedKey)!, comment: ""), for: .normal)
            button.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
            button.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
//            button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
//            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            horizonStack.addArrangedSubview(button)
            initialButton = button
        }
        
        for (index, selectionItem) in selectionList.enumerated() {
            if let selected, selected == selectionItem.uuid { initialButton?.tag = index; continue }
            let button = UIButton(configuration: .plain())
            var conf = button.configuration
            conf?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            button.setTitle(NSLocalizedString(selectionItem.locolizedKey, comment: ""), for: .normal)
            button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
            button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            
            button.tag = index
            
            button.translatesAutoresizingMaskIntoConstraints = false
//            button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
//            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.isHidden = true
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            horizonStack.addArrangedSubview(button)
            expandButtonList.append(button)
        }
    }
    
    func setSelectionList(selectionList: [(UUID, String)], selected: UUID?) {
        self.selected = selected
        super.setSelectionList(selectionList: selectionList)
        setView()
    }
}

extension SingleSelectionExpandable: SelectionButtonCanUpdate {
    func updateSelectionButtonStatus() {
        var exchangeIndex: Int?
        for (index, button) in expandButtonList.enumerated() {
//            if button.title(for: .normal) == selected {
//                button.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
//                button.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
//                exchangeIndex = index
//            } else {
//                button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
//                button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
//            }
            if selected == selectionList[button.tag].uuid {
                button.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
            } else {
                button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
            }
        }
        if let initialButton {
            if selectionList[initialButton.tag].uuid == selected {
                initialButton.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
                initialButton.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
            } else {
                initialButton.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
                initialButton.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
            }
        }
        
        if let exchangeIndex, var unwrappedButton = initialButton {
            swap(&unwrappedButton, &expandButtonList[exchangeIndex])
            initialButton = unwrappedButton
            horizonStack.subviews.forEach { $0.removeFromSuperview() }
            horizonStack.addArrangedSubview(unwrappedButton)
            for button in expandButtonList {
                horizonStack.addArrangedSubview(button)
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton) {
        if selected == selectionList[sender.tag].uuid {
            
        } else {
            selected = selectionList[sender.tag].uuid
            updateSelectionButtonStatus()
        }
    }
}

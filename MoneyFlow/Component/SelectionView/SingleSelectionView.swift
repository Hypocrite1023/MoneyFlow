//
//  SingleSelectionButtonView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/25.
//

import UIKit
import Combine

class SingleSelectionView: SelectionView, ObservableObject {

    var mayNil: Bool
    @Published var selectedIndex: Int? {
        didSet {
            if selectedIndex != nil {
                updateButtonStatus()
            }
        }
    }
    
//    static let singleSelectionButtonStateChangeNotification: NSNotification.Name = NSNotification.Name("SingleSelectionButtonStateChangeNotification")
    
    
    init(selectionList: [String], mayNil: Bool = false, preselectIndex: Int? = nil) {
        self.mayNil = mayNil
        self.selectedIndex = preselectIndex
        super.init(selectionList: selectionList)
        if preselectIndex != nil {
            updateButtonStatus()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setView() {
        super.setView()
        for button in self.buttonList {
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
        
    }
    
    internal func updateSelectionList(list: [String]) {
        self.selectionList = list
        horizonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        setView()
    }
    
    open func updateButtonStatus() {
        for (index, button) in buttonList.enumerated() {
            if index == selectedIndex {
                button.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
            } else {
                button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
            }
        }
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        if selectedIndex != sender.tag || selectedIndex == nil {
            selectedIndex = sender.tag
            updateButtonStatus()
//            NotificationCenter.default.post(name: SingleSelectionView.singleSelectionButtonStateChangeNotification, object: self)
        }
    }
    
}

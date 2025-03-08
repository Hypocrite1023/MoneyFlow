//
//  MultiSelectionExpandable.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/26.
//

import UIKit

class MultiSelectionExpandable: SelectionViewExpandable {
    
    @Published var selected: Set<String> = []
    private var initialButton: [UIButton] = []
    lazy var placeHolder: UILabel = UILabel()
    private let prompt: String
    
    init(selected: Set<String> = [], height: CGFloat = 30, width: CGFloat = 60, spacing: CGFloat = 10, selectedNilPrompt: String) {
        self.prompt = selectedNilPrompt
        super.init(height: height, width: width, spacing: spacing)
//        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        if selected.isEmpty {
            placeHolder.text = "沒有選擇\(prompt)"
            placeHolder.font = AppConfig.Font.tertiaryTitle.value
            buttonScrollView.addSubview(placeHolder)
            placeHolder.translatesAutoresizingMaskIntoConstraints = false
            placeHolder.leadingAnchor.constraint(equalTo: buttonScrollView.leadingAnchor).isActive = true
            placeHolder.heightAnchor.constraint(equalTo: buttonScrollView.heightAnchor).isActive = true
            self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        for title in Array(selected) {
            let button = UIButton(configuration: .plain())
            var conf = button.configuration
            conf?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            button.setTitle(title, for: .normal)
            button.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
            button.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            horizonStack.addArrangedSubview(button)
            initialButton.append(button)
        }
            
        
        
        for title in selectionList {
            if selected.contains(title) { continue }
            let button = UIButton(configuration: .plain())
            var conf = button.configuration
            conf?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            button.setTitle(title, for: .normal)
            button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
            button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isHidden = true
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            horizonStack.addArrangedSubview(button)
            expandButtonList.append(button)
        }
    }
    
    override func expandToggle(expand: Bool) {
        super.expandToggle(expand: expand)
        if expand {
            placeHolder.isHidden = true
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.2,
                delay: 0.3,
                options: [.curveEaseOut],
                animations: {
                    self.placeHolder.transform = CGAffineTransform(translationX: -200, y: 0)
                }
            )
        } else {
            if selected.isEmpty {
                placeHolder.isHidden = false
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.2,
                    delay: 0.3,
                    options: [.curveEaseOut],
                    animations: {
                        self.placeHolder.transform = .identity
                    }
                )
            }
        }
    }
    
    func setSelectionList(selectionList: [String], selected: Set<String> = []) {
        self.selected = selected
        super.setSelectionList(selectionList: selectionList)
        setView()
    }
}

extension MultiSelectionExpandable: SelectionButtonCanUpdate {
    func updateSelectionButtonStatus() {
        for (index, button) in expandButtonList.enumerated() {
            if selected.contains(button.title(for: .normal)!) {
                button.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
                initialButton.append(expandButtonList.remove(at: index))
            } else {
                button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
                button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
            }
        }
        for (index, button) in initialButton.enumerated() {
            if selected.contains(button.title(for: .normal)!) {
                button.backgroundColor = AppConfig.ButtonColor.selected.backgroundColor
                button.setTitleColor(AppConfig.ButtonColor.selected.fontColor, for: .normal)
            } else {
                button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
                button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
                expandButtonList.append(initialButton.remove(at: index))
            }
        }
        
        horizonStack.subviews.forEach { $0.removeFromSuperview() }
        for button in initialButton {
            horizonStack.addArrangedSubview(button)
        }
        for button in expandButtonList {
            horizonStack.addArrangedSubview(button)
        }
    }
    
    @objc func buttonAction(sender: UIButton) {
        if selected.contains(sender.title(for: .normal)!) {
            selected.remove(sender.title(for: .normal)!)
        } else {
            selected.insert(sender.title(for: .normal)!)
        }
        updateSelectionButtonStatus()
    }
}

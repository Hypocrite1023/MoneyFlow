//
//  SingleSelectionButtonView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/25.
//

import UIKit

class SingleSelectionButtonView: UIView {

    var selectionList: [String]?
    var mayNil: Bool?
    static let singleSelectionButtonStateChangeNotification: NSNotification.Name = NSNotification.Name("SingleSelectionButtonStateChangeNotification")
    
    private let horizonScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let horizonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    internal var buttonList: [UIButton] = []
    internal var selected: Set<String> = []
    
    init(selectionList: [String]?, mayNil: Bool = false) {
        self.selectionList = selectionList
        self.mayNil = mayNil
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
        
        subviews.forEach { $0.removeFromSuperview() }
        for (_, selection) in selectionList!.enumerated() {
            let button = UIButton(configuration: .plain())
            var conf = button.configuration
            conf?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.setTitle(selection, for: .normal)
            button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
            button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
            button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            buttonList.append(button)
            horizonStackView.addArrangedSubview(button)
        }
        
        horizonScrollView.addSubview(horizonStackView)
        horizonStackView.leadingAnchor.constraint(equalTo: horizonScrollView.leadingAnchor).isActive = true
        horizonStackView.trailingAnchor.constraint(equalTo: horizonScrollView.trailingAnchor).isActive = true
        horizonStackView.topAnchor.constraint(equalTo: horizonScrollView.topAnchor).isActive = true
        horizonStackView.bottomAnchor.constraint(equalTo: horizonScrollView.bottomAnchor).isActive = true
        horizonStackView.heightAnchor.constraint(equalTo: horizonScrollView.heightAnchor).isActive = true
        
        self.addSubview(horizonScrollView)
        horizonScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        horizonScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        horizonScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        horizonScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    internal func updateTagsButtons(tags: [String]) {
        self.selectionList = tags
        horizonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        setView()
    }
    
    open func updateButtonStatus() {
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
    
    @objc func buttonAction(_ sender: UIButton) {
        if !selected.contains(sender.title(for: .normal)!) {
            selected = [sender.title(for: .normal)!]
            updateButtonStatus()
            NotificationCenter.default.post(name: SingleSelectionButtonView.singleSelectionButtonStateChangeNotification, object: self)
        }
    }
    
}

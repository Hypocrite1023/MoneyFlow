//
//  SelectionView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/25.
//

import UIKit

class SelectionView: UIView {
    
    internal var buttonList: [UIButton] = []
    var selectionList: [String]
    
    let horizonScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    let horizonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    init(selectionList: [String]) {
        self.selectionList = selectionList
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
        buttonList = []
        subviews.forEach { $0.removeFromSuperview() }
        for (index, selection) in selectionList.enumerated() {
            let button = UIButton(configuration: .plain())
            button.tag = index
            var conf = button.configuration
            conf?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.setTitle(selection, for: .normal)
            button.setTitleColor(AppConfig.ButtonColor.unselected.fontColor, for: .normal)
            button.backgroundColor = AppConfig.ButtonColor.unselected.backgroundColor
            button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
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
}

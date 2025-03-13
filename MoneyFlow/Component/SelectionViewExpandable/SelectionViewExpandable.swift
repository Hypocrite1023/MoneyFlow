//
//  SelectionViewExpandable.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/26.
//

import UIKit

class SelectionViewExpandable: UIView {
    
    var buttonScrollView: UIScrollView = UIScrollView()
    var selectionList: [(uuid: UUID, locolizedKey: String)] = []
    var expandButtonList: [UIButton] = []
    var horizonStack: UIStackView = UIStackView()
    
    
    var buttonHeight: CGFloat
    var buttonWidth: CGFloat
    var stackSpacing: CGFloat
    
    var expand: Bool = false {
        didSet {
            expandToggle(expand: expand)
        }
    }
    
    init(height: CGFloat = 30, width: CGFloat = 60, spacing: CGFloat = 10) {
        self.buttonHeight = height
        self.buttonWidth = width
        self.stackSpacing = spacing
        super.init(frame: .zero)
        setScrollViewAndStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setScrollViewAndStack() {
        
        addSubview(buttonScrollView)
        buttonScrollView.showsVerticalScrollIndicator = false
        buttonScrollView.showsHorizontalScrollIndicator = false
        
        buttonScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonScrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        buttonScrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        buttonScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        buttonScrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        horizonStack.axis = .horizontal
        horizonStack.spacing = stackSpacing
        horizonStack.distribution = .fillProportionally
        horizonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonScrollView.addSubview(horizonStack)
        
        horizonStack.leadingAnchor.constraint(equalTo: buttonScrollView.leadingAnchor).isActive = true
        horizonStack.trailingAnchor.constraint(equalTo: buttonScrollView.trailingAnchor).isActive = true
        horizonStack.topAnchor.constraint(equalTo: buttonScrollView.topAnchor).isActive = true
        horizonStack.bottomAnchor.constraint(equalTo: buttonScrollView.bottomAnchor).isActive = true
        horizonStack.heightAnchor.constraint(equalTo: buttonScrollView.heightAnchor).isActive = true
    }
    
    func expandToggle(expand: Bool) {
        if expand {
            showExpand()
        } else {
            hideExpand()
        }
    }
    
    private func showExpand() {
        for (index, button) in expandButtonList.enumerated() {
            button.isHidden = false
            button.transform = CGAffineTransform(translationX: (buttonWidth + 10) * CGFloat(index + 1), y: 0)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.1 * TimeInterval(index),
                delay: 0.1 * TimeInterval(index),
                options: [.curveEaseOut],
                animations: {
                    button.transform = .identity
                }
            )
        }
    }
    
    private func hideExpand() {
        for (index, button) in expandButtonList.reversed().enumerated() {
            button.isHidden = false
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.05 * TimeInterval(index),
                delay: TimeInterval(index) * 0.05,
                options: [.curveEaseOut],
                animations: {
                    button.transform = CGAffineTransform(translationX: self.buttonWidth * CGFloat(index + 1), y: 0)
                },
                completion: { _ in
                    button.isHidden = true
                }
            )
        }
    }
    
    func setSelectionList(selectionList: [(uuid: UUID, locolizedKey: String)]) {
        self.selectionList = selectionList
    }
}

protocol SelectionButtonCanUpdate {
    func buttonAction(sender: UIButton)
    func updateSelectionButtonStatus()
}

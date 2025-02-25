//
//  FilterPanelView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/15.
//

import UIKit

class FilterPanelView: UIView {

    private let filterByTimeLabel: UILabel = createLabel(title: "日期")
    let dateRangeSelector: SingleSelectionView = SingleSelectionView(selectionList: CoreDataPredicate.TransactionDateRange.allCases.map { $0.title }, preselectIndex: 0)
    private let filterByTypeLabel: UILabel = createLabel(title: "類型")
    let typeSelector: MultiSelectionView = MultiSelectionView(selectionList: ["收入", "支出"], preselectIndex: [0, 1])
    private let filterByCategoryLabel: UILabel = createLabel(title: "類別")
    let categorySelector: MultiSelectionView = MultiSelectionView(selectionList: CoreDataManager.shared.fetchAllTransactionCategories())
    private let filterByPaymentMethodLabel: UILabel = createLabel(title: "交易方式")
    let paymentMethodSelector: MultiSelectionView = MultiSelectionView(selectionList: CoreDataManager.shared.fetchAllTransactionPaymentMethods())
    private let filterByTagLabel: UILabel = createLabel(title: "標籤")
    let tagSelector: MultiSelectionView = MultiSelectionView(selectionList: CoreDataManager.shared.fetchAllTransactionTags(), mayNil: true, selectionListNilPrompt: "尚未建立任何標籤")
//    private let filterByAmountLabel: UILabel = createLabel(title: "金額")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        let vStack = UIStackView(arrangedSubviews: [
            createStack(arrangedSubviews: [filterByTimeLabel, dateRangeSelector], spacing: 8),
            createStack(arrangedSubviews: [filterByTypeLabel, typeSelector], spacing: 8),
            createStack(arrangedSubviews: [filterByCategoryLabel, categorySelector], spacing: 8),
            createStack(arrangedSubviews: [filterByPaymentMethodLabel, paymentMethodSelector], spacing: 8),
            createStack(arrangedSubviews: [filterByTagLabel, tagSelector], spacing: 8),
//            createStack(arrangedSubviews: [filterByAmountLabel, UIView()], spacing: 8)
        ])
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.spacing = 10
        
        addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        vStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        vStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    }
    
    private static func createLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = AppConfig.Font.title.value
        return label
    }
    
    private func createStack(arrangedSubviews: [UIView], spacing: CGFloat) -> UIStackView {
        let vsStack = UIStackView(arrangedSubviews: arrangedSubviews)
        vsStack.axis = .vertical
        vsStack.distribution = .fillEqually
        vsStack.spacing = spacing
        return vsStack
    }

}

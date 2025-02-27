//
//  TransactionDetailView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/25.
//

import UIKit

class TransactionDetailView: UIView {
        
    private let pageScrollView: UIScrollView = UIScrollView()
    private let pageStack: UIStackView = UIStackView()
    private let dateLabel: UILabel = createLabel(title: "日期")
    let accountingDatePicker: UIDatePicker = UIDatePicker()
    private let typeLabel: UILabel = createLabel(title: "類型")
    var typeSelectionView: SingleSelectionExpandable = SingleSelectionExpandable()
    private let itemNameLabel: UILabel = createLabel(title: "項目名稱")
    var itemNameTextField: UITextField = UITextField()
    private let amountLabel: UILabel = createLabel(title: "金額")
    var amountTextField: UITextField = UITextField()
    private let categoryLabel: UILabel = createLabel(title: "類別")
    var categorySelectionView: SingleSelectionExpandable = SingleSelectionExpandable()
    private let paymentMethodLabel: UILabel = createLabel(title: "支付方式")
    var paymentMethodSelectionView: SingleSelectionExpandable = SingleSelectionExpandable()
    private let tagLabel: UILabel = createLabel(title: "標籤")
    var tagSelectionView: MultiSelectionExpandable = MultiSelectionExpandable(selectedNilPrompt: "標籤")
    let addTagButton: UIButton = UIButton(configuration: .plain())
    
    private let noteLabel: UILabel = createLabel(title: "備註")
    let noteTextField: UITextField = UITextField()
    
    let incomeDistributeLabel: UILabel = createLabel(title: "將收入分配給")
//    let incomedistributeTableView: UITableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(pageScrollView)
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.translatesAutoresizingMaskIntoConstraints = false
        pageScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        pageScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        pageScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        pageScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true

        pageScrollView.addSubview(pageStack)
        pageStack.translatesAutoresizingMaskIntoConstraints = false
        pageStack.axis = .vertical
        pageStack.spacing = 20
        pageStack.alignment = .leading
        pageStack.distribution = .fillProportionally
        pageStack.topAnchor.constraint(equalTo: pageScrollView.topAnchor, constant: 10).isActive = true
        pageStack.bottomAnchor.constraint(equalTo: pageScrollView.bottomAnchor, constant: -20).isActive = true
        pageStack.widthAnchor.constraint(equalTo: pageScrollView.widthAnchor).isActive = true
        
        setupDateBlock()
        setupTypeBlock()
        setupItemNameBlock()
        setupAmountBlock()
        setupCategoryBlock()
        setupPaymentMethodBlock()
        setupTagsBlock()
        setupNotesBlock()
//        setupIncomeDistributeBlock()
    }
    
    private func setupDateBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(dateLabel)
        vstack.addArrangedSubview(accountingDatePicker)
        accountingDatePicker.isEnabled = false
        accountingDatePicker.datePickerMode = .date
        accountingDatePicker.contentHorizontalAlignment = .left
        
        let divider = createDivider()
        setupDivider(vstack, divider)
        
        pageStack.addArrangedSubview(vstack)
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupTypeBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(typeLabel)
        vstack.addArrangedSubview(typeSelectionView)
        
        let divider = createDivider()
        setupDivider(vstack, divider)
        pageStack.addArrangedSubview(vstack)
        
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupItemNameBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(itemNameLabel)
        vstack.addArrangedSubview(itemNameTextField)
        itemNameTextField.isEnabled = false
        itemNameTextField.keyboardType = .default
        itemNameTextField.borderStyle = .roundedRect
        let divider = createDivider()
        setupDivider(vstack, divider)
        
        pageStack.addArrangedSubview(vstack)
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupAmountBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(amountLabel)
        vstack.addArrangedSubview(amountTextField)
        amountTextField.isEnabled = false
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
        let divider = createDivider()
        setupDivider(vstack, divider)
        pageStack.addArrangedSubview(vstack)
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupCategoryBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(categoryLabel)
        vstack.addArrangedSubview(categorySelectionView)
        categorySelectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let divider = createDivider()
        setupDivider(vstack, divider)
        pageStack.addArrangedSubview(vstack)
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupPaymentMethodBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(paymentMethodLabel)
        vstack.addArrangedSubview(paymentMethodSelectionView)
        
        let divider = createDivider()
        setupDivider(vstack, divider)
        pageStack.addArrangedSubview(vstack)
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupTagsBlock() {
        let vstack = createVStack()
        let view = UIView()
        var conf = UIButton.Configuration.plain()
        conf.imagePlacement = .trailing
        conf.image = UIImage(systemName: "chevron.forward")
        conf.title = "新增標籤"
        conf.buttonSize = .mini
        addTagButton.configuration = conf
        addTagButton.tintColor = .black
        addTagButton.layer.cornerRadius = 5
        addTagButton.layer.borderWidth = 1
        addTagButton.layer.borderColor = UIColor.black.cgColor
        addTagButton.clipsToBounds = true
        
        view.addSubview(tagLabel)
        view.addSubview(addTagButton)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        addTagButton.translatesAutoresizingMaskIntoConstraints = false
        
        tagLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tagLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tagLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        addTagButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addTagButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        vstack.addArrangedSubview(view)
        vstack.addArrangedSubview(tagSelectionView)
        
        let divider = createDivider()
        setupDivider(vstack, divider)
        pageStack.addArrangedSubview(vstack)
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupNotesBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(noteLabel)
        noteTextField.borderStyle = .roundedRect
        noteTextField.keyboardType = .default
        noteTextField.returnKeyType = .done
        vstack.addArrangedSubview(noteTextField)
        noteTextField.isEnabled = false
        
        let divider = createDivider()
        setupDivider(vstack, divider)
        pageStack.addArrangedSubview(vstack)
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
//    private func setupIncomeDistributeBlock() {
//        let vstack = createVStack()
//        vstack.addArrangedSubview(incomeDistributeLabel)
//        vstack.addArrangedSubview(incomedistributeTableView)
//        incomedistributeTableView.allowsMultipleSelection = false
//        vstack.translatesAutoresizingMaskIntoConstraints = false
//        vstack.heightAnchor.constraint(equalToConstant: 300).isActive = true
//        pageStack.addArrangedSubview(vstack)
//        
//        constraintToWidth(innerView: vstack, outerView: pageStack)
//    }
    
    
    func setTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        itemNameTextField.delegate = delegate
//        itemNameTextField.tag = 0
        amountTextField.delegate = delegate
//        amountTextField.tag = 1
        noteTextField.delegate = delegate
//        noteTextField.tag = 2
    }
    
    func setScrollViewDelegate(_ delegate: UIScrollViewDelegate) {
        pageScrollView.delegate = delegate
    }
    
    
    
    private static func createLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }
    
    private func createVStack() -> UIStackView {
        let vstack = UIStackView()
        vstack.translatesAutoresizingMaskIntoConstraints = false
        vstack.axis = .vertical
        vstack.spacing = 8
//        vstack.alignment = .leading
//        vstack.distribution = .fill
        return vstack
    }
    
    private func constraintToWidth(innerView: UIView, outerView: UIView) {
        innerView.translatesAutoresizingMaskIntoConstraints = false

        innerView.widthAnchor.constraint(equalTo: outerView.widthAnchor).isActive = true
    }
    
    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .systemGray5
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }
    
    fileprivate func setupDivider(_ vstack: UIStackView, _ divider: UIView) {
        vstack.addArrangedSubview(divider)
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalTo: vstack.widthAnchor).isActive = true
    }
    
    func updateStatus(status: Bool) {
        accountingDatePicker.isEnabled = status
        itemNameTextField.isEnabled = status
        amountTextField.isEnabled = status
        noteTextField.isEnabled = status
        
        typeSelectionView.expand = status
        categorySelectionView.expand = status
        paymentMethodSelectionView.expand = status
        tagSelectionView.expand = status
    }

}

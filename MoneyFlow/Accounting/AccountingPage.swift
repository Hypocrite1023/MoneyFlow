//
//  AccountingPage.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/23.
//


//    基本資訊
//        1.    日期 (Date)
//        •    記錄每筆交易的發生時間。通常需要精確到日，也可以加上時間（例如：購物或收入的具體時間）。
//        •    使用者可以根據日期進行分類或檢視。
//        2.    類型 (Type)
//        •    支出 (Expense)
//        •    收入 (Income)
//        3.    金額 (Amount)
//        •    每筆記錄的具體金額。可以選擇顯示幣別（例如：TWD、USD）。
//        4.    類別 (Category)
//        •    支出的分類（例如：餐飲、交通、娛樂、購物、醫療）。
//        •    收入的分類（例如：薪水、投資收益、禮金、副業收入）。
//        •    支援自定義分類：允許使用者新增自己習慣的分類。
//    進階資訊
//        5.    支付方式 (Payment Method)
//        •    現金 (Cash)
//        •    信用卡 (Credit Card)
//        •    行動支付（例如：Apple Pay、Google Pay、Line Pay）
//        •    銀行轉帳
//        6.    帳戶 (Account)
//        •    允許區分不同帳戶，例如：現金、銀行帳戶、信用卡帳戶。
//        7.    標籤 (Tags)
//        •    為記錄添加標籤，方便未來搜尋（例如：「生日聚會」或「旅遊」）。
//        8.    交易對象 (Payee/Payer)
//        •    支出記錄的對象（例如：某個商店、餐廳或朋友）。
//        •    收入記錄的來源（例如：公司、顧客）。
//        9.    備註 (Notes)
//        •    允許使用者添加詳細說明（例如：「聚餐 AA 制」、「電商購物訂單編號」）。
//    額外資訊
//        10.    收據或憑證 (Attachments)
//        •    允許使用者拍照或上傳收據、發票、憑證。
//        11.    地點 (Location)
//        •    記錄交易發生的地點，方便後續回顧（例如：用餐地點或購物商場）。
//        12.    循環記錄 (Recurring Transactions)
//        •    如果是固定每月發生的交易（例如房租、水電費、訂閱費用），可自動生成。
//        13.    貨幣類型 (Currency)
//        •    如果記錄跨國交易，允許選擇不同貨幣，並顯示匯率轉換的金額。
//        14.    照片或相關圖片 (Photos)
//        •    添加相關商品照片或收據。
//    進階功能的延伸記錄
//        15.    目標或預算 (Budget or Goal Tracking)
//        •    使用者可以為某個類別設置預算，記錄每月花費是否超標。
//        16.    交易狀態 (Transaction Status)
//        •    已付款 (Paid) 或未付款 (Unpaid)。
//        •    若是未來的交易（例如借款或分期付款），可設置還款提醒。
//        17.    分組或共享 (Group or Shared Transactions)
//        •    如果交易涉及多人分擔（例如共同旅行或團購），記錄每人的分擔金額。
//        18.    提醒 (Reminder)
//        •    提醒重要的支出或收入（例如貸款到期日、信用卡繳款日）。
import UIKit

class AccountingPage: UIView {
    
    private let pageScrollView: UIScrollView = UIScrollView()
    private let pageStack: UIStackView = UIStackView()
    private let dateLabel: UILabel = createLabel(title: "日期")
    let accountingDatePicker: UIDatePicker = UIDatePicker()
    private let typeLabel: UILabel = createLabel(title: "類型")
    let typeSegmentControl: UISegmentedControl = UISegmentedControl(items: ["支出", "收入"])
    private let itemNameLabel: UILabel = createLabel(title: "項目名稱")
    let itemNameTextField: UITextField = UITextField()
    private let amountLabel: UILabel = createLabel(title: "金額")
    let amountTextField: UITextField = UITextField()
    private let categoryLabel: UILabel = createLabel(title: "類別")
    let categoryControl: SingleSelectionView
    private let paymentMethodLabel: UILabel = createLabel(title: "支付方式")
    let paymentMethodControl: SingleSelectionView
    private let tagLabel: UILabel = createLabel(title: "標籤")
    let addTagButton: UIButton = UIButton(configuration: .plain())
    let tagControl: MultiSelectionView
    
    private let noteLabel: UILabel = createLabel(title: "備註")
    let noteTextField: UITextField = UITextField()
    
    let incomeDistributeLabel: UILabel = createLabel(title: "將收入分配給")
    let incomedistributeTableView: UITableView = UITableView()
    
    let accountingButton: UIButton = UIButton(configuration: .tinted())
    let cancelAccountingButton: UIButton = UIButton(configuration: .tinted())
    
    init(categoryList: [String], paymentMethodList: [String], tagList: [String]) {
        categoryControl = SingleSelectionView(selectionList: categoryList, preselectIndex: nil)
        paymentMethodControl = SingleSelectionView(selectionList: paymentMethodList, preselectIndex: nil)
        tagControl = MultiSelectionView(selectionList: tagList, mayNil: true)
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
//        pageScrollView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor).isActive = true
        pageScrollView.addSubview(pageStack)
        pageStack.translatesAutoresizingMaskIntoConstraints = false
        pageStack.axis = .vertical
        pageStack.spacing = 20
        pageStack.alignment = .leading
        pageStack.distribution = .fillProportionally
        pageStack.topAnchor.constraint(equalTo: pageScrollView.topAnchor, constant: 10).isActive = true
//        pageStack.leadingAnchor.constraint(equalTo: pageScrollView.leadingAnchor, constant: 0).isActive = true
//        pageStack.trailingAnchor.constraint(equalTo: pageScrollView.trailingAnchor, constant: -0).isActive = true
        pageStack.bottomAnchor.constraint(equalTo: pageScrollView.bottomAnchor, constant: 0).isActive = true
        pageStack.widthAnchor.constraint(equalTo: pageScrollView.widthAnchor).isActive = true
        setupDateBlock()
        setupTypeBlock()
        setupItemNameBlock()
        setupAmountBlock()
        setupCategoryBlock()
        setupPaymentMethodBlock()
        setupTagsBlock()
        setupNotesBlock()
        setupIncomeDistributeBlock()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
        setFlowAccountingButton()
    }
    
    @objc private func closeKeyboard() {
        self.endEditing(true)
    }
    
    private func setFlowAccountingButton() {
        let horizonStack = UIStackView(arrangedSubviews: [cancelAccountingButton, accountingButton])
        horizonStack.translatesAutoresizingMaskIntoConstraints = false
        horizonStack.axis = .horizontal
        horizonStack.spacing = 10
        horizonStack.alignment = .center
        horizonStack.distribution = .fillEqually
        pageScrollView.addSubview(horizonStack)
        accountingButton.setTitle("紀錄！", for: .normal)
        
        
        cancelAccountingButton.setTitle("取消", for: .normal)
        cancelAccountingButton.tintColor = .darkGray
        
        horizonStack.bottomAnchor.constraint(equalTo: pageScrollView.frameLayoutGuide.bottomAnchor, constant: -15).isActive = true
        horizonStack.centerXAnchor.constraint(equalTo: pageScrollView.frameLayoutGuide.centerXAnchor).isActive = true
        
        
    }
    
    private func setupDateBlock() {
        accountingDatePicker.datePickerMode = .date
        let vstack = createVStack()
        vstack.addArrangedSubview(dateLabel)
        vstack.addArrangedSubview(accountingDatePicker)
        accountingDatePicker.contentHorizontalAlignment = .leading
        
        
        pageStack.addArrangedSubview(vstack)
        
    }
    
    private func setupTypeBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(typeLabel)
        vstack.addArrangedSubview(typeSegmentControl)
        
        
        pageStack.addArrangedSubview(vstack)
        
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupItemNameBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(itemNameLabel)
        vstack.addArrangedSubview(itemNameTextField)
        itemNameTextField.keyboardType = .default
        itemNameTextField.borderStyle = .roundedRect
        
        
        pageStack.addArrangedSubview(vstack)
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupAmountBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(amountLabel)
        vstack.addArrangedSubview(amountTextField)
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
                
        pageStack.addArrangedSubview(vstack)
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupCategoryBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(categoryLabel)
        vstack.addArrangedSubview(categoryControl)
        
        
        
        pageStack.addArrangedSubview(vstack)
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupPaymentMethodBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(paymentMethodLabel)
        vstack.addArrangedSubview(paymentMethodControl)
        
        
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
//        addTagButton.setTitle("新增標籤", for: .normal)
//        addTagButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        
        view.addSubview(tagLabel)
        view.addSubview(addTagButton)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        addTagButton.translatesAutoresizingMaskIntoConstraints = false
        
        tagLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tagLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tagLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        addTagButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addTagButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        addTagButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        addTagButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        vstack.addArrangedSubview(view)
        vstack.addArrangedSubview(tagControl)
        
        
        pageStack.addArrangedSubview(vstack)
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupNotesBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(noteLabel)
        noteTextField.borderStyle = .roundedRect
        noteTextField.placeholder = "加入一些簡單的說明吧"
        noteTextField.keyboardType = .default
        noteTextField.returnKeyType = .done
        vstack.addArrangedSubview(noteTextField)
        
        
        pageStack.addArrangedSubview(vstack)
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupIncomeDistributeBlock() {
        let vstack = createVStack()
        vstack.addArrangedSubview(incomeDistributeLabel)
        vstack.addArrangedSubview(incomedistributeTableView)
        incomedistributeTableView.allowsMultipleSelection = false
        vstack.translatesAutoresizingMaskIntoConstraints = false
        vstack.heightAnchor.constraint(equalToConstant: 300).isActive = true
        pageStack.addArrangedSubview(vstack)
        
        constraintToWidth(innerView: vstack, outerView: pageStack)
    }
    
    private func setupPictureBlock() {
        
    }
    
    private func setupLocationBlock() {
        
    }
    
    private func setupRecurringTransactionBlock() {
        
    }
    
    func setTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        itemNameTextField.delegate = delegate
        itemNameTextField.tag = 0
        amountTextField.delegate = delegate
        amountTextField.tag = 1
        noteTextField.delegate = delegate
        noteTextField.tag = 2
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
}

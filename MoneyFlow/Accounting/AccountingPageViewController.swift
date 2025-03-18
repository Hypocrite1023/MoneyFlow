//
//  AccountingPageViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/4.
//

import UIKit
import Combine

class AccountingPageViewController: UIViewController {
    
    private let viewModel: AccountingPageViewModel
    private var bindings: Set<AnyCancellable> = Set<AnyCancellable>()
    private var contentView: AccountingPage = AccountingPage(categoryList: CoreDataManager.shared.fetchTransactionCategories(predicate: .type(categoryType: CoreDataInitializer.shared.transactionTypeUUID[1])).map {($0.uuid, $0.name)}, paymentMethodList: CoreDataManager.shared.fetchAllTransactionPaymentMethods().map {($0.uuid, $0.paymentMethod)}, tagList: CoreDataManager.shared.fetchAllTransactionTags().map {($0.uuid, $0.tag)})
    
    private var activeTextField: UITextField?
    private var accountingTagManager: AccountingTagManager = AccountingTagManager.shared
    
    init(viewModel: AccountingPageViewModel = AccountingPageViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 觀察鍵盤
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMultiSelectionButtonStatus), name: AccountingTagManager.addTagNotificationName, object: nil)
        
        contentView.setTextFieldDelegate(self)
        contentView.setScrollViewDelegate(self)
        
        contentView.incomedistributeTableView.delegate = self
        contentView.incomedistributeTableView.dataSource = self
        contentView.incomedistributeTableView.register(GoalPreviewView.self, forCellReuseIdentifier: "IncomeDistributeTableViewCell")
//        contentView.incomedistributeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "IncomeDistributeTableViewCell")
        contentView.incomedistributeTableView.rowHeight = 60
        
        contentView.addTagButton.addTarget(self, action: #selector(addTag), for: .touchUpInside)
        contentView.accountingButton.addTarget(self, action: #selector(makeAccounting), for: .touchUpInside)
        contentView.cancelAccountingButton.addTarget(self, action: #selector(cancelAccounting), for: .touchUpInside)
        
        setBinding()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AccountingTagManager.addTagNotificationName, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setBinding() {
        func bindViewToViewModel() {
            contentView.itemNameTextField.publisher(for: \.text)
                .receive(on: RunLoop.main)
                .assign(to: \.transactionName, on: viewModel)
                .store(in: &bindings)
            contentView.amountTextField.publisher(for: \.text)
                .receive(on: RunLoop.main)
                .assign(to: \.transactionAmount, on: viewModel)
                .store(in: &bindings)
            contentView.noteTextField.publisher(for: \.text)
                .receive(on: RunLoop.main)
                .assign(to: \.transactionNote, on: viewModel)
                .store(in: &bindings)
            contentView.accountingDatePicker.publisher(for: \.date)
                .receive(on: RunLoop.main)
                .assign(to: \.transactionDate, on: viewModel)
                .store(in: &bindings)
//            contentView.categoryControl.$selectedIndex
//                .map {
//                    if let index = $0 {
//                        return self.contentView.categoryControl.buttonList[index].title(for: .normal)
//                    } else {
//                        return nil
//                    }
//                }
//                .receive(on: RunLoop.main)
//                .assign(to: \.transactionCategory, on: viewModel)
//                .store(in: &bindings)
            contentView.paymentMethodControl.$selectedIndex
//                .map {
//                    if let index = $0 {
//                        return index
//                    } else {
//                        return nil
//                    }
//                }
                .receive(on: RunLoop.main)
                .assign(to: \.transactionPaymentMethod, on: viewModel)
                .store(in: &bindings)
            contentView.typeSegmentControl.publisher(for: \.selectedSegmentIndex)
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] selectedIndex in
                    if selectedIndex == UISegmentedControl.noSegment {
                        self?.contentView.incomeDistributeLabel.isHidden = true
                        self?.contentView.incomedistributeTableView.isHidden = true
                    } else {
                        if selectedIndex == 1 {
                            self?.contentView.incomeDistributeLabel.isHidden = false
                            self?.contentView.incomedistributeTableView.isHidden = false
//                            self?.contentView.configureCategoryControl(type: .type(uuid: CoreDataInitializer.shared.transactionTypeUUID[selectedIndex]))
                        } else {
                            self?.contentView.incomeDistributeLabel.isHidden = true
                            self?.contentView.incomedistributeTableView.isHidden = true
//                            self?.contentView.configureCategoryControl(type: .expense)
                        }
                        self?.contentView.configureCategoryControl(type: .type(uuid: CoreDataInitializer.shared.transactionTypeUUID[selectedIndex]))
                        self?.viewModel.transactionType = CoreDataInitializer.shared.transactionTypeUUID[selectedIndex]
                    }
                    
                })
                .store(in: &bindings)
            contentView.tagControl.$selectedIndex
                .map {
                    let selectedArr = Array($0)
//                    let result = selectedArr.map { i in
//                        return self.contentView.tagControl.buttonList[i].title(for: .normal)!
//                    }
                    return selectedArr
                }
                .receive(on: RunLoop.main)
                .assign(to: \.transactionTag, on: viewModel)
                .store(in: &bindings)
        }
        func bindViewModelToView() {
            viewModel.$selectedCurrency
                .receive(on: DispatchQueue.main)
                .sink { [weak self] currency in
                    self?.contentView.currencySelectionButton.setTitle(currency, for: .normal)
                }
                .store(in: &bindings)
            viewModel.$currencies
                .receive(on: DispatchQueue.main)
                .replaceNil(with: [])
                .sink { [weak self] currencies in
                    self?.setCurrencyButtonMenu(supportCurrencyList: currencies)
                }
                .store(in: &bindings)
        }
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    @objc func addTag() {
        let alertController = UIAlertController(title: "新增標籤", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        alertController.addAction(UIAlertAction(title: "確認", style: .default, handler: { action in
            guard let inputTag = alertController.textFields?.first?.text else {
                return
            }
            print(inputTag)
            self.viewModel.addTag(tag: inputTag)
        }))
        self.present(alertController, animated: true)
        alertController.textFields?.first?.becomeFirstResponder()
    }
    
    @objc func handleMultiSelectionButtonStatus() {
        DispatchQueue.main.async {
            self.contentView.tagControl.updateSelectionList(list: CoreDataManager.shared.fetchAllTransactionTags().map { ($0.uuid, $0.tag) })
        }
    }
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        guard let keyboardInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let activeTextField else { return }
        let keyboardTop = keyboardInfo.minY
        let textFieldFrameInView = activeTextField.convert(activeTextField.bounds, to: view)
        print(keyboardTop, textFieldFrameInView.maxY)
        if textFieldFrameInView.maxY > keyboardTop {
            print("been hide")
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -(textFieldFrameInView.maxY - keyboardTop + 20))
            }
        }
    }
    
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }
    
    @objc func makeAccounting() {
        if let index = contentView.categoryControl.selectedIndex {
            viewModel.transactionCategory = index
        }
        
        let result = viewModel.makeAccounting()
        switch result {
            case .success(_):
                self.dismiss(animated: true)
            case .failure(let error):
                print(error)
            
                let alertController = UIAlertController(title: "錯誤", message: error.errorMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
        }
    }
    
    @objc func cancelAccounting() {
        self.dismiss(animated: true)
    }
    
    func setCurrencyButtonMenu(supportCurrencyList: [CurrencyInformation.Information]) {
        let menuItem = supportCurrencyList.map {
            if $0.shortCode == viewModel.selectedCurrency {
                UIAction(title: $0.name, subtitle: $0.shortCode, state: .on) { action in
                    self.viewModel.selectedCurrency = action.subtitle ?? ""
                    let resetMenuItem = supportCurrencyList.map {
                        if $0.shortCode == self.viewModel.selectedCurrency {
                            UIAction(title: $0.name, subtitle: $0.shortCode, state: .on) { action in
                                self.viewModel.selectedCurrency = action.subtitle ?? ""
                            }
                        } else {
                            UIAction(title: $0.name, subtitle: $0.shortCode) { action in
                                self.viewModel.selectedCurrency = action.subtitle ?? ""
                            }
                        }
                    }
                    self.contentView.currencySelectionButton.menu = UIMenu(title: "", options: [.singleSelection], children: resetMenuItem)
                }
            } else {
                UIAction(title: $0.name, subtitle: $0.shortCode) { action in
                    self.viewModel.selectedCurrency = action.subtitle ?? ""
                    let resetMenuItem = supportCurrencyList.map {
                        if $0.shortCode == self.viewModel.selectedCurrency {
                            UIAction(title: $0.name, subtitle: $0.shortCode, state: .on) { action in
                                self.viewModel.selectedCurrency = action.subtitle ?? ""
                            }
                        } else {
                            UIAction(title: $0.name, subtitle: $0.shortCode) { action in
                                self.viewModel.selectedCurrency = action.subtitle ?? ""
                            }
                        }
                    }
                    self.contentView.currencySelectionButton.menu = UIMenu(title: "", options: [.singleSelection], children: resetMenuItem)
                }
            }
        }
        let menu = UIMenu(title: "", options: [.singleSelection], children: menuItem)
        contentView.currencySelectionButton.menu = menu
        contentView.currencySelectionButton.showsMenuAsPrimaryAction = true
    }
}

extension AccountingPageViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}

extension AccountingPageViewController: UIScrollViewDelegate {
    
}

extension AccountingPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.goalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeDistributeTableViewCell", for: indexPath) as? GoalPreviewView else {
            return UITableViewCell()
        }
        
        cell.goalUUID = viewModel.goalList[indexPath.row].id
        cell.setGoalName(goalName: viewModel.goalList[indexPath.row].name!)
        cell.setGoalAmount(goalAmount: viewModel.goalList[indexPath.row].targetAmount)
        cell.setNowAmount(nowAmount: viewModel.goalList[indexPath.row].currentAmount)
        cell.setGoalProgressView(progress: viewModel.goalList[indexPath.row].currentAmount / viewModel.goalList[indexPath.row].targetAmount)
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! GoalPreviewView
//        print(cell.goalUUID!)
        viewModel.relationGoalID = cell.goalUUID!
//        tableView.deselectRow(at: indexPath, animated: true)
        cell.setHighlighted(true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GoalPreviewView
        viewModel.relationGoalID = nil
        cell.setHighlighted(false, animated: true)
    }
    
}

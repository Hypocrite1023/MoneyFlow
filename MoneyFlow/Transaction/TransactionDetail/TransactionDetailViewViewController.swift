//
//  TransactionDetailViewViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/25.
//

import UIKit
import Combine

class TransactionDetailViewViewController: UIViewController {
    
    private let contentView: TransactionDetailView
    private let viewModel: TransactionDetailViewViewModel
    private var bindings: Set<AnyCancellable> = []
    var editAccountingToolBarItem: UIBarButtonItem?
    var editDoneToolBarItem: UIBarButtonItem?
    var cancelEditToolBarItem: UIBarButtonItem?
    private var activeTextField: UITextField?
    
    init(transaction: Transaction, viewModel: TransactionDetailViewViewModel) {
        self.contentView = TransactionDetailView()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func loadView() {
        view = contentView
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        editAccountingToolBarItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAccountingToolBarItemTapped))
        editDoneToolBarItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        cancelEditToolBarItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        navigationItem.rightBarButtonItem = editAccountingToolBarItem
        
        let cancelKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        cancelKeyboardGesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(cancelKeyboardGesture)
        
        setupBinding()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        contentView.setTextFieldDelegate(self)
        setupViewValues()
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupViewValues() {
        contentView.accountingDatePicker.date = viewModel.date
        contentView.typeSelectionView.setSelectionList(selectionList: CoreDataManager.shared.fetchAllTransactionType().map { ($0.uuid, $0.nsLocalizedStringIdentifier) }, selected: viewModel.type)
        contentView.itemNameTextField.text = viewModel.itemName
        contentView.amountTextField.text = viewModel.amount.description
        contentView.categorySelectionView.setSelectionList(selectionList: CoreDataManager.shared.fetchTransactionCategories(predicate: .type(categoryType: viewModel.type)).map {($0.uuid, $0.name)}, selected: viewModel.category)
        contentView.paymentMethodSelectionView.setSelectionList(selectionList: CoreDataManager.shared.fetchAllTransactionPaymentMethods().map {($0.uuid, $0.paymentMethod)}, selected: viewModel.payMethod)
        contentView.tagSelectionView.setSelectionList(selectionList: CoreDataManager.shared.fetchAllTransactionTags().map {($0.uuid, $0.tag)}, selected: Set(viewModel.tags ?? []))
        contentView.noteTextField.text = viewModel.note
        if viewModel.note == "" || viewModel.note == nil {
            contentView.noteTextField.placeholder = NSLocalizedString("TransactionDetailView_NoteTextField_Placeholder_Title", comment: "沒有輸入任何備註")
        }
    }
    
    func setupBinding() {
        func bindViewModelToView() {
            viewModel.$isEditing
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isEditing in
                    self?.contentView.updateStatus(status: isEditing)
                }
                .store(in: &bindings)
            viewModel.$date
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: \.date, on: contentView.accountingDatePicker)
                .store(in: &bindings)
            viewModel.$type
                .removeDuplicates()
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .assign(to: \.selected, on: contentView.typeSelectionView)
                .store(in: &bindings)
            viewModel.$itemName
                .removeDuplicates()
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .assign(to: \.text, on: contentView.itemNameTextField)
                .store(in: &bindings)
            viewModel.$amount
                .removeDuplicates()
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .assign(to: \.text, on: contentView.amountTextField)
                .store(in: &bindings)
            viewModel.$category
                .removeDuplicates()
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .assign(to: \.selected, on: contentView.categorySelectionView)
                .store(in: &bindings)
            viewModel.$payMethod
                .removeDuplicates()
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .assign(to: \.selected, on: contentView.paymentMethodSelectionView)
                .store(in: &bindings)
            viewModel.$tags
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] tag in
                    self?.contentView.tagSelectionView.selected = tag == nil ? [] : Set(tag!)
                })
                .store(in: &bindings)
            viewModel.$note
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: \.text, on: contentView.noteTextField)
                .store(in: &bindings)
        }
        func bindViewToViewModel() {
            contentView.accountingDatePicker.publisher(for: \.date)
                .removeDuplicates()
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .assign(to: \.date, on: viewModel)
                .store(in: &bindings)
            contentView.typeSelectionView.$selected
                .removeDuplicates()
                .dropFirst()
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.type, on: viewModel)
                .store(in: &bindings)
            contentView.itemNameTextField.publisher(for: \.text)
                .removeDuplicates()
                .dropFirst()
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.itemName, on: viewModel)
                .store(in: &bindings)
            contentView.amountTextField.publisher(for: \.text)
                .removeDuplicates()
                .dropFirst()
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.amount, on: viewModel)
                .store(in: &bindings)
            contentView.categorySelectionView.$selected
                .removeDuplicates()
                .dropFirst()
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.category, on: viewModel)
                .store(in: &bindings)
            contentView.paymentMethodSelectionView.$selected
                .removeDuplicates()
                .dropFirst()
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.payMethod, on: viewModel)
                .store(in: &bindings)
            contentView.tagSelectionView.$selected
                .removeDuplicates()
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] value in
                    self?.viewModel.tags = value.isEmpty ? nil : Array(value)
                })
                .store(in: &bindings)
            contentView.noteTextField.publisher(for: \.text)
                .removeDuplicates()
                .dropFirst()
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.note, on: viewModel)
                .store(in: &bindings)
                
        }
        bindViewModelToView()
        bindViewToViewModel()
    }
    
    @objc func editAccountingToolBarItemTapped() {
        viewModel.toggleEditing()
        navigationItem.rightBarButtonItems = [editDoneToolBarItem!, cancelEditToolBarItem!]
    }
    
    @objc func doneButtonTapped() {
        // date picker date publisher 沒有正常運作 需要額外設定date
        viewModel.date = contentView.accountingDatePicker.date
        if viewModel.isTransactionModified() {
            var transaction = Transaction(date: viewModel.date, type: viewModel.type, itemName: viewModel.itemName, amount: Double(viewModel.amount)!, currencyCode: viewModel.currencyCode, category: viewModel.category, payMethod: viewModel.payMethod, tags: viewModel.tags, note: viewModel.note, relationGoal: viewModel.relationGoal)
            transaction.id = viewModel.transaction.id!
            let result = CoreDataManager.shared.modifyTransaction(transaction)
            
            switch result {
                case .success(_):
                    navigationItem.rightBarButtonItems = [editAccountingToolBarItem!]
                    viewModel.toggleEditing()
                case .failure(let error):
                    print(error)
                
                let alertController = UIAlertController(title: NSLocalizedString("TransactionDetailView_ErrorMessage_Title", comment: "錯誤"), message: error.errorMessage, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: NSLocalizedString("TransactionDetailView_ErrorMessage_Message", comment: "好"), style: .default) { _ in
    //                        print("")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true)
                
                
            }
        } else {
            navigationItem.rightBarButtonItems = [editAccountingToolBarItem!]
            viewModel.toggleEditing()
        }
    }
    
    @objc func cancelButtonTapped() {
        viewModel.resetTransaction()
        viewModel.toggleEditing()
        navigationItem.rightBarButtonItems = [editAccountingToolBarItem!]
    }
    
    @objc private func closeKeyboard() {
        
        contentView.endEditing(true)
    }
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        guard let keyboardInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let activeTextField else { return }
        let keyboardTop = keyboardInfo.minY
        let textFieldFrameInView = activeTextField.convert(activeTextField.bounds, to: contentView)
        print(keyboardTop, textFieldFrameInView.maxY)
        if textFieldFrameInView.maxY > keyboardTop {
            print("been hide")
            UIView.animate(withDuration: 0.3) {
                self.contentView.transform = CGAffineTransform(translationX: 0, y: -(textFieldFrameInView.maxY - keyboardTop + 120))
            }
        }
    }
    
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }
}

extension TransactionDetailViewViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

//
//  AccountingPageViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/4.
//

import UIKit

class AccountingPageViewController: UIViewController {
    
    private var activeTextField: UITextField?
    private var accountingTagManager: AccountingTagManager = AccountingTagManager.shared
    
    override func loadView() {
        view = AccountingPage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        // 觀察鍵盤
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMultiSelectionButtonStatus), name: AccountingTagManager.addTagNotificationName, object: nil)
        if let accountingPage = view as? AccountingPage {
            accountingPage.setTextFieldDelegate(self)
            accountingPage.setScrollViewDelegate(self)
            accountingPage.delegate = self
            
            accountingPage.addTagButton.addTarget(self, action: #selector(addTag), for: .touchUpInside)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AccountingTagManager.addTagNotificationName, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func addTag() {
        let alertController = UIAlertController(title: "新增標籤", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        alertController.addAction(UIAlertAction(title: "確認", style: .default, handler: { action in
//            print(alertController.textFields?.first?.text)
            guard let inputTag = alertController.textFields?.first?.text else {
                print("nil nil")
                return
            }
            print(inputTag)
            self.accountingTagManager.addTag(inputTag)
        }))
        self.present(alertController, animated: true)
    }
    
    @objc func handleMultiSelectionButtonStatus() {
        print("handle")
        if let accountingPage = view as? AccountingPage {
            print("handle")
            DispatchQueue.main.async {
                accountingPage.tagControl.updateTagsButtons(tags: Array(AccountingTagManager.shared.getTags()!))
            }
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
}

extension AccountingPageViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}

extension AccountingPageViewController: UIScrollViewDelegate {
    
}

extension AccountingPageViewController: CloseAccountingPage {
    func closeAccountingPage() {
        self.dismiss(animated: true)
    }
    
    
}

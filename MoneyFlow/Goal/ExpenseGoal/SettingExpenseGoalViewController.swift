//
//  SettingExpenseGoalViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/2.
//

import UIKit
import Combine

class SettingExpenseGoalViewController: UIViewController {
    
    private let contentView: SettingExpenseGoalView
    private let viewModel: SettingExpenseGoalViewModel
    private var bindings: Set<AnyCancellable> = []
    
    init(viewModel: SettingExpenseGoalViewModel = SettingExpenseGoalViewModel()) {
        self.contentView = SettingExpenseGoalView()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBindings()
        setTargetAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setBindings() {
        func bindViewModelToView() {
            viewModel.$dailyGoal
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] dailyGoal in
                    self?.contentView.dailyExpenseTextField.text = dailyGoal
                }
                .store(in: &bindings)
            viewModel.$weeklyGoal
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] weeklyGoal in
                    self?.contentView.weeklyExpenseTextField.text = weeklyGoal
                }
                .store(in: &bindings)
            viewModel.$monthlyGoal
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] monthlyGoal in
                    self?.contentView.monthlyExpenseTextField.text = monthlyGoal
                }
                .store(in: &bindings)
        }
        func bindViewToViewModel() {
            contentView.dailyExpenseTextField.publisher(for: \.text)
                .dropFirst()
                .compactMap { $0 }
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] text in
                    self?.viewModel.dailyGoal = text
                }
                .store(in: &bindings)
            contentView.weeklyExpenseTextField.publisher(for: \.text)
                .dropFirst()
                .compactMap { $0 }
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] text in
                    self?.viewModel.weeklyGoal = text
                }
                .store(in: &bindings)
            contentView.monthlyExpenseTextField.publisher(for: \.text)
                .dropFirst()
                .compactMap { $0 }
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] text in
                    self?.viewModel.monthlyGoal = text
                }
                .store(in: &bindings)
        }
        bindViewModelToView()
        bindViewToViewModel()
    }
    
    private func setTargetAction() {
        let closeKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        contentView.addGestureRecognizer(closeKeyboardGesture)
        contentView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped() {
        contentView.dailyExpenseTextField.text = viewModel.originalDailyGoal
        contentView.weeklyExpenseTextField.text = viewModel.originalWeeklyGoal
        contentView.monthlyExpenseTextField.text = viewModel.originalMonthlyGoal
    }
    
    @objc func saveButtonTapped() {
        let result = viewModel.setExpenseGoal()
        switch result {
            
        case .success(_):
            alert(title: "成功", message: "設定花費目標成功", type: .success)
        case .failure(let error):
            alert(title: "錯誤", message: error.info, type: .fail)
        }
    }
    
    @objc func closeKeyboard() {
        contentView.endEditing(true)
    }
    
    func alert(title: String, message: String, type: SettingExpenseGoalViewModel.ExpenseStatus) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch type {
        case .success:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alertController.dismiss(animated: true)
            }
        case .fail:
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
        }
        present(alertController, animated: true)
    }
}

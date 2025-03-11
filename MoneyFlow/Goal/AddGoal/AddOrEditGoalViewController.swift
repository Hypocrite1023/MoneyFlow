//
//  AddGoalViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/17.
//

import UIKit
import Combine

class AddOrEditGoalViewController: UIViewController {
    
    private let viewModel: AddOrEditGoalViewViewModel
    private let contentView: AddOrEditGoalView
    private var bindings: Set<AnyCancellable> = []
    
    init(viewModel: AddOrEditGoalViewViewModel) {
        self.viewModel = viewModel
        self.contentView = AddOrEditGoalView(mode: viewModel.mode)
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

        // Do any additional setup after loading the view.
        
        contentView.closeButton.addTarget(self, action: #selector(closeAddGoalView), for: .touchUpInside)
        contentView.setButton.addTarget(self, action: #selector(configurationGoal), for: .touchUpInside)
        
        contentView.goalTimePeriodSwitch.addTarget(self, action: #selector(goalTimePeriodSwitchDidChange), for: .valueChanged)
        let closeKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(closeKeyboardGesture)
        setBindings()
        if viewModel.startDate != nil { // 限制目標開始日期不能修改提前
            contentView.goalTimePeriodStartDatePicker.minimumDate = viewModel.startDate
        }
        
        contentView.goalAmountTextFieldKeyboardDoneButtonItem.target = self
        contentView.goalAmountTextFieldKeyboardDoneButtonItem.action = #selector(closeKeyboard)
    }
    
    private func setBindings() {
        func bindViewModelToView() {
            viewModel.$name
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: \.text, on: contentView.goalNameTextField)
                .store(in: &bindings)
            viewModel.$amount
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: \.text, on: contentView.goalAmountTextField)
                .store(in: &bindings)
            viewModel.$startDate
                .removeDuplicates()
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.date, on: contentView.goalTimePeriodStartDatePicker)
                .store(in: &bindings)
            viewModel.$endDate
                .removeDuplicates()
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] date in
                    self?.contentView.goalTimePeriodEndDatePicker.date = date
                    self?.contentView.goalTimePeriodEndDatePicker.minimumDate = date
                })
//                .assign(to: \.date, on: contentView.goalTimePeriodEndDatePicker)
                .store(in: &bindings)
            viewModel.$noEndDate
                .removeDuplicates()
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] isOn in
                    self?.contentView.goalTimePeriodSwitch.isOn = isOn
                    self?.contentView.goalTimePeriodEndDatePicker.isHidden = isOn
                    self?.contentView.goalTimePeriodInfiniteReplaceDatePickerLabel.isHidden = !isOn
                })
                .store(in: &bindings)
        }
        func bindViewToViewModel() {
            contentView.goalNameTextField.publisher(for: \.text)
                .dropFirst()
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: \.name, on: viewModel)
                .store(in: &bindings)
            contentView.goalAmountTextField.publisher(for: \.text)
                .dropFirst()
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: \.amount, on: viewModel)
                .store(in: &bindings)
//            contentView.goalTimePeriodStartDatePicker.publisher(for: \.date)
//                .dropFirst()
//                .removeDuplicates()
//                .map { print($0); return Optional($0) }
//                .receive(on: DispatchQueue.main)
//                .assign(to: \.startDate, on: viewModel)
//                .store(in: &bindings)
        }
        bindViewModelToView()
        bindViewToViewModel()
    }
    
    @objc func closeAddGoalView() {
        self.dismiss(animated: true)
    }
    
    @objc func goalTimePeriodSwitchDidChange(sender: UISwitch) {
        if sender.isOn {
            contentView.goalTimePeriodEndDatePicker.isHidden = true
            contentView.goalTimePeriodInfiniteReplaceDatePickerLabel.isHidden = false
        } else {
            contentView.goalTimePeriodEndDatePicker.isHidden = false
            contentView.goalTimePeriodInfiniteReplaceDatePickerLabel.isHidden = true
        }
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func configurationGoal() {
        viewModel.startDate = contentView.goalTimePeriodStartDatePicker.date
        viewModel.endDate = contentView.goalTimePeriodEndDatePicker.date
        viewModel.noEndDate = contentView.goalTimePeriodSwitch.isOn
        var result: AddOrEditGoalViewViewModel.GoalOperateResult
        switch viewModel.mode {
        case .add:
            result = viewModel.addGoal()
        case .edit:
            result = viewModel.modifyGoal()
        }
        
        switch result {
            
        case .success(_):
            self.dismiss(animated: true)
        case .failure(let error):
            errorAlert(title: NSLocalizedString("AddOrEditGoalView_ConfigurationGoal_Error_Title", comment: ""), message: error.infoMessage)
        }
    }
    
    func errorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("AddOrEditGoalView_ConfigurationGoal_Ok_Title", comment: ""), style: .default) { _ in
            
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

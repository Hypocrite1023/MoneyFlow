//
//  AnalysisViewViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/5.
//

import UIKit
import Combine
import DGCharts

class AnalysisViewViewController: UIViewController {
    
    private let viewModel: AnalysisViewViewModel
    private let contentView: AnalysisView = AnalysisView()
    private var bindings: Set<AnyCancellable> = []
    
    init(viewModel: AnalysisViewViewModel = AnalysisViewViewModel()) {
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

        // Do any additional setup after loading the view.
        setBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    private func setBindings() {
        func bindViewToViewModel() {
            contentView.yearMonthPicker.$selectedYear
                .dropFirst()
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: \.selectedYear, on: viewModel)
                .store(in: &bindings)
            
            contentView.yearMonthPicker.$selectedMonth
                .dropFirst()
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: \.selectedMonth, on: viewModel)
                .store(in: &bindings)
        }
        func bindViewModelToView() {
            viewModel.$rhsExpense
                .zip(viewModel.$lhsExpense)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] rhsExpense, lhsExpense in
                    self?.contentView.monthExpenseAnalysisCardView.setupAmount(amount: rhsExpense)
                    let value = (rhsExpense - lhsExpense) / lhsExpense
                    self?.contentView.monthExpenseAnalysisCardView.setupCompare(value: value, increase: value <= 0)
                }
                .store(in: &bindings)
            viewModel.$rhsIncome
                .zip(viewModel.$lhsIncome)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] rhsIncome, lhsIncome in
                    self?.contentView.monthIncomeAnalysisCardView.setupAmount(amount: rhsIncome)
                    let value = (rhsIncome - lhsIncome) / lhsIncome
                    self?.contentView.monthIncomeAnalysisCardView.setupCompare(value: value, increase: value >= 0)
                }
                .store(in: &bindings)
            viewModel.$rhsBalance
                .zip(viewModel.$lhsBalance)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] rhsBalance, lhsBalance in
                    self?.contentView.monthBalanceAnalysisCardView.setupAmount(amount: rhsBalance)
                    let value = (rhsBalance - lhsBalance) / abs(lhsBalance)
                    self?.contentView.monthBalanceAnalysisCardView.setupCompare(value: value, increase: value >= 0)
                }
                .store(in: &bindings)
            viewModel.$commonUsedPaymentMethodString
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .map {
                    if $0 == "" {
                        return Optional(NSLocalizedString("AnalysisView_CommonUsedPaymentMethodString_Nil_Title", comment: "這個月還沒有任何記帳資料"))
                    } else {
                        return $0
                    }
                }
                .assign(to: \.text, on: contentView.mostCommonlyUsedPaymentMethod)
                .store(in: &bindings)
            viewModel.$commonUsedTagString
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .map {
                    if $0 == "" {
                        return Optional(NSLocalizedString("AnalysisView_CommonUsedTagString_Nil_Title", comment: "這個月沒有任何記帳資料使用到標籤"))
                    } else {
                        return $0
                    }
                }
                .assign(to: \.text, on: contentView.mostCommonlyUsedTag)
                .store(in: &bindings)
            viewModel.$expensePieChartData
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    self?.contentView.configPieChart(data: data)
                    self?.contentView.expensePiechartSetting(empty: data.isEmpty)
                }
                .store(in: &bindings)
            viewModel.$expenseGroupByCategoryDict
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] dict in
                    self?.contentView.configCategoryExpenseList(categoryExpenseDictionary: dict)
                }
                .store(in: &bindings)
            viewModel.$expenseGroupByPaymentMethodDict
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] dict in
                    self?.contentView.configPaymentMethodBarChart(paymentMethodExpenseDictionary: dict)
                }
                .store(in: &bindings)
        }
        bindViewToViewModel()
        bindViewModelToView()
    }
}

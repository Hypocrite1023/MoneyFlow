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
        contentView.monthExpenseAnalysisCardView.setupValues(title: "總支出", amount: 10000, compare: "10%")
        contentView.monthIncomeAnalysisCardView.setupValues(title: "總收出", amount: 10000, compare: "10%")
        contentView.monthBalanceAnalysisCardView.setupValues(title: "結餘", amount: 10000, compare: "10%")
        contentView.mostCommonlyUsedPaymentMethod.text = "現金、信用卡"
        contentView.mostCommonlyUsedTag.text = "早餐、午餐、晚餐"
        var data = [PieChartDataEntry]()
        data.append(PieChartDataEntry(value: 45, label: "食物"))
        data.append(PieChartDataEntry(value: 25, label: "交通"))
        data.append(PieChartDataEntry(value: 30, label: "娛樂"))
        contentView.configPieChart(data: data)
        
        contentView.configTagExpenseList(tagExpenseDictionary: ["早餐": 1000, "晚餐": 2000, "午餐": 3000, "交通": 4000, "娛樂": 5000])
        contentView.configPaymentMethodBarChart(paymentMethodExpenseDictionary: ["現金": 10, "信用卡": 20, "ATM": 30, "轉帳": 40])
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
        bindViewToViewModel()
    }
}

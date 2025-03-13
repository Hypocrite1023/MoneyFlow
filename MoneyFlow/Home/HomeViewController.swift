//
//  ViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/16.
//

import UIKit
import Combine
import DGCharts

class HomeViewController: UIViewController {
    
    var homeView: HomeView = HomeView()
    private let viewModel: HomeViewModel
    private var bindings: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        
        let randomGenerateTransaction = RandomGenerateTransaction()
        randomGenerateTransaction.createRandomTransactionRecord()
        homeView.viewDetailButton.addTarget(self, action: #selector(jumpToDetailView), for: .touchUpInside)
        
        homeView.setBudgetButton.addTarget(self, action: #selector(setBudget), for: .touchUpInside)
        
        for dateRange in CoreDataPredicate.TransactionDateRange.allCases {
            print(dateRange.title, homeView.segementControl.numberOfSegments)
            homeView.segementControl.insertSegment(withTitle: dateRange.localized, at: homeView.segementControl.numberOfSegments, animated: false)
        }
        homeView.segementControl.selectedSegmentIndex = 0
        setBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadExpenseAndIncomeData()
        viewModel.reloadTransactionData()
        resetChartDataSet()
    }
    
    private func setBindings() {
        func bindViewToViewModel() {
            homeView.segementControl.publisher(for: \.selectedSegmentIndex)
                .receive(on: DispatchQueue.main)
                .map { print($0); return $0 }
                .assign(to: \.selectedDateRange, on: viewModel)
                .store(in: &bindings)
        }
        func bindViewModelToView() {
            viewModel.$expense
                .map {
                    AppFormatter.shared.currencyNumberFormatter.string(from: NSNumber(value: $0 ?? 0)) ?? ""
                }
                .assign(to: \.balanceLabel.text, on: homeView.totalSpent)
                .store(in: &bindings)
            viewModel.$income
                .map {
                    AppFormatter.shared.currencyNumberFormatter.string(from: NSNumber(value: $0 ?? 0)) ?? ""
                }
                .assign(to: \.balanceLabel.text, on: homeView.totalIncome)
                .store(in: &bindings)
            viewModel.$selectedDateRange
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
                    self?.viewModel.reloadTransactionData()
                    self?.viewModel.reloadExpenseAndIncomeData()
                    self?.resetChartDataSet()
                }
                .store(in: &bindings)
        }
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    private func resetChartDataSet() {
        var expenseEntries: [ChartDataEntry] = []
        var incomeEntries: [ChartDataEntry] = []
        if let expense = viewModel.sevenUnitExpense, let income = viewModel.sevenUnitIncome {
            for (index, expense) in expense.enumerated() {
                expenseEntries.append(ChartDataEntry(x: Double(index), y: expense))
            }
            
            for (index, income) in income.enumerated() {
                incomeEntries.append(ChartDataEntry(x: Double(index), y: income))
            }
        }
        
        
        let expenseDataSet = LineChartDataSet(entries: expenseEntries, label: NSLocalizedString("HomeView_LineChartDataSet_Expense_Label", comment: ""))
        expenseDataSet.colors = [.systemBlue]
        expenseDataSet.circleColors = [.black] // 資料點顏色
        expenseDataSet.circleRadius = 5.0
        expenseDataSet.lineWidth = 3
        expenseDataSet.drawValuesEnabled = false
        
        let incomeDataSet = LineChartDataSet(entries: incomeEntries, label: NSLocalizedString("HomeView_LineChartDataSet_Income_Label", comment: ""))
        incomeDataSet.colors = [.systemRed]
        incomeDataSet.circleColors = [.systemGray] // 資料點顏色
        incomeDataSet.circleRadius = 5.0
        incomeDataSet.lineWidth = 2.0
        incomeDataSet.drawValuesEnabled = false
        
        homeView.transactionLineChartView.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: viewModel.sevenUnitDates ?? [])
        homeView.transactionLineChartView.lineChartView.data = LineChartData(dataSets: [expenseDataSet, incomeDataSet])
        
        homeView.transactionLineChartView.lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 1)
    }
    
    @objc func jumpToDetailView() {
        tabBarController?.selectedIndex = 1
    }
    
    @objc func setBudget() {
        let vc = SettingExpenseGoalViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


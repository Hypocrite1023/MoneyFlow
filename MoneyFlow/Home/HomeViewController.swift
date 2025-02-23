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
        
//        let randomGenerateTransaction = RandomGenerateTransaction()
//        randomGenerateTransaction.createRandomTransactionRecord()
        homeView.viewDetailButton.addTarget(self, action: #selector(jumpToDetailView), for: .touchUpInside)
        
        for dateRange in HomeViewModel.DateRange.allCases {
            homeView.segementControl.insertSegment(withTitle: dateRange.title, at: 0, animated: false)
        }
        homeView.segementControl.selectedSegmentIndex = 0
        setBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setBindings() {
        func bindViewToViewModel() {
            homeView.segementControl.publisher(for: \.selectedSegmentIndex)
                .receive(on: DispatchQueue.main)
                .assign(to: \.selectedDateRange, on: viewModel)
                .store(in: &bindings)
        }
        func bindViewModelToView() {
            viewModel.$expense
                .map {
                    AppNumberFormatter.shared.currencyNumberFormatter.string(from: NSNumber(value: $0 ?? 0)) ?? ""
                }
                .assign(to: \.balanceLabel.text, on: homeView.totalSpent)
                .store(in: &bindings)
            viewModel.$income
                .map {
                    AppNumberFormatter.shared.currencyNumberFormatter.string(from: NSNumber(value: $0 ?? 0)) ?? ""
                }
                .assign(to: \.balanceLabel.text, on: homeView.totalIncome)
                .store(in: &bindings)
            viewModel.$selectedDateRange
                .sink { [weak self] index in
                    self?.reloadTransactionLineChart(unit: .init(rawValue: index)!)
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
        
        
        let expenseDataSet = LineChartDataSet(entries: expenseEntries, label: "花費")
        expenseDataSet.colors = [.systemBlue]
        expenseDataSet.circleColors = [.black] // 資料點顏色
        expenseDataSet.circleRadius = 5.0
        expenseDataSet.lineWidth = 3
        expenseDataSet.drawValuesEnabled = false
        
        let incomeDataSet = LineChartDataSet(entries: incomeEntries, label: "收入")
        incomeDataSet.colors = [.systemRed]
        incomeDataSet.circleColors = [.systemGray] // 資料點顏色
        incomeDataSet.circleRadius = 5.0
        incomeDataSet.lineWidth = 2.0
        incomeDataSet.drawValuesEnabled = false
        
        homeView.transactionLineChartView.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: viewModel.sevenUnitDates ?? [])
        homeView.transactionLineChartView.lineChartView.data = LineChartData(dataSets: [expenseDataSet, incomeDataSet])
        
        homeView.transactionLineChartView.lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 1)
    }
    
    func reloadTransactionLineChart(unit: AppDateGenerater.DateUnit) {
        viewModel.sevenUnitExpense = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: unit).map{ (_, startDate, endDate) in
            return CoreDataManager.shared.fetchTransactionWith(withSpecifyDateRange: (startDate, endDate), type: .expense)?.reduce(0) { $0 + $1.amount } ?? 0
        }
        viewModel.sevenUnitIncome = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: unit).map{ (_, startDate, endDate) in
            return CoreDataManager.shared.fetchTransactionWith(withSpecifyDateRange: (startDate, endDate), type: .income)?.reduce(0) { $0 + $1.amount } ?? 0
        }
        viewModel.sevenUnitDates = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: unit).map{ (dateString, _, _) in
            return dateString
        }
        
        resetChartDataSet()
    }
    
    @objc func jumpToDetailView() {
        tabBarController?.selectedIndex = 1
    }

}


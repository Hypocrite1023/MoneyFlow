//
//  TransactionLineChartView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/15.
//

import UIKit
import DGCharts

class TransactionLineChartView: UIView {
    
    private var lineChartView: LineChartView?
    private var dailyExpense: [Double] = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: .day).map{ (_, startDate, endDate) in
        return CoreDataManager.shared.fetchTransactionWith(withSpecifyDateRange: (startDate, endDate), type: .expense)?.reduce(0) { $0 + $1.amount } ?? 0
    }
    private var dailyIncome: [Double] = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: .day).map{ (_, startDate, endDate) in
        return CoreDataManager.shared.fetchTransactionWith(withSpecifyDateRange: (startDate, endDate), type: .income)?.reduce(0) { $0 + $1.amount } ?? 0
    }
    private var dates: [String] = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: .day).map{ (dateString, _, _) in
        return dateString
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
        // 初始化 LineChartView
        lineChartView = LineChartView()
        lineChartView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineChartView!)
        
        NSLayoutConstraint.activate([
            lineChartView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            lineChartView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            lineChartView!.topAnchor.constraint(equalTo: topAnchor),
            lineChartView!.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        setupChartData()
    }
    
    private func setupChartData() {
        resetChartDataSet()
        
        // 自訂 X 軸的標籤
        lineChartView?.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        lineChartView!.xAxis.granularity = 1
        lineChartView?.xAxis.labelRotationAngle = 45
        lineChartView?.xAxis.avoidFirstLastClippingEnabled = true
        
        // 其他樣式設定
        lineChartView?.xAxis.labelPosition = .bottom
        lineChartView?.rightAxis.enabled = false // 隱藏右邊的 Y 軸
        lineChartView?.leftAxis.enabled = false
        lineChartView?.doubleTapToZoomEnabled = false
        lineChartView?.pinchZoomEnabled = false
        lineChartView?.dragEnabled = false
        
    }
    
    func loadMoreTransactionLineChart() {
        
    }
    
    fileprivate func resetChartDataSet() {
        var expenseEntries: [ChartDataEntry] = []
        var incomeEntries: [ChartDataEntry] = []
        
        for (index, expense) in dailyExpense.enumerated() {
            expenseEntries.append(ChartDataEntry(x: Double(index), y: expense))
        }
        
        for (index, income) in dailyIncome.enumerated() {
            incomeEntries.append(ChartDataEntry(x: Double(index), y: income))
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
        
        lineChartView!.data = LineChartData(dataSets: [expenseDataSet, incomeDataSet])
        
//        lineChartView?.animate(xAxisDuration: 1)
        lineChartView?.animate(xAxisDuration: 0.5, yAxisDuration: 1)
    }
    
    func reloadTransactionLineChart(unit: AppDateGenerater.DateUnit) {
        dailyExpense = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: unit).map{ (_, startDate, endDate) in
            return CoreDataManager.shared.fetchTransactionWith(withSpecifyDateRange: (startDate, endDate), type: .expense)?.reduce(0) { $0 + $1.amount } ?? 0
        }
        dailyIncome = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: unit).map{ (_, startDate, endDate) in
            return CoreDataManager.shared.fetchTransactionWith(withSpecifyDateRange: (startDate, endDate), type: .income)?.reduce(0) { $0 + $1.amount } ?? 0
        }
        dates = AppDateGenerater.shared.generatePastSevenUnitDateInfo(from: .now, unit: unit).map{ (dateString, _, _) in
            return dateString
        }
        
        resetChartDataSet()
    }
}

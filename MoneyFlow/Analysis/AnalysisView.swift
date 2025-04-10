//
//  AnalysisView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/5.
//

/*
 時間範圍篩選按鈕（預設為「本月」，可選「上月」、「自訂範圍」）
 1️⃣ 摘要資訊（統計概覽）

 📌 顯示方式：使用 卡片視圖（三欄橫向滾動）

 📌 統計卡片
     1.    本月總支出（金額 + 與上月比較%）
     2.    本月總收入（金額 + 與上月比較%）
     3.    本月結餘（收入 - 支出）（綠色：盈餘、紅色：虧損）

 📌 其他摘要
     •    最常使用的支付方式（標示 現金 / 信用卡 / 電子支付）
     •    最常使用的標籤（顯示最多次使用的標籤，如「早餐 x8」、「聚會 x5」
 2️⃣ 支出分析

 📌 顯示方式：圖表 + 列表視圖（卡片顯示關鍵數據）

 📌 類別分析
     •    圓餅圖：顯示支出類別（食物、交通、娛樂等）占比
     •    文字標示：列出花費最多的前三大類別（例如：「食物 $5,000（40%）」）

 📌 標籤分析
     •    列表顯示標籤與支出金額
     •    例如：「早餐 $1,500（10%）」、「聚會 $2,000（15%）」

 📌 支付方式統計
     •    長條圖顯示各支付類別支出比例
     •    例如：「現金 50%、信用卡 30%、電子支付 20%」
 3️⃣ 收入分析

 📌 顯示方式：長條圖 + 列表

 📌 收入來源
     •    長條圖：顯示不同收入來源（薪水、投資、紅包等）的占比
 5️⃣ 消費習慣

 📌 顯示方式：數據統計 + 折線圖

 📌 平均每筆消費
     •    卡片顯示：「本月平均每筆消費 $450」

 📌 消費趨勢
     •    折線圖：
     •    每日消費趨勢（顯示每日支出變化）
     •    每週 / 每月消費趨勢（比較不同時期的消費變化）
 */

import UIKit
import DGCharts

class AnalysisView: UIView {

    private let wholePageScrollView: UIScrollView = UIScrollView()
    private let wholePageContentView: UIView = UIView()
    // 總支出、總收入、結餘
    private let analysisViewTitleLabel: UILabel = createLabel(title: NSLocalizedString("AnalysisView_AnalysisViewTitleLabel_Title", comment: "分析"), font: AppConfig.Font.title.value)
    let yearMonthPicker: YearMonthPicker = YearMonthPicker(yearList: Array(2020...Calendar.current.component(.year, from: .now)), selectedYear: Calendar.current.component(.year, from: .now), selectedMonth: Calendar.current.component(.month, from: .now))
    // MARK: - 摘要
    private let analysisSummaryLabel: UILabel = createLabel(title: NSLocalizedString("AnalysisView_AnalysisSummaryLabel_Title", comment: "摘要"), font: AppConfig.Font.secondaryTitle.value)
    private let analysisCardHScrollView: UIScrollView = UIScrollView()
    private let analysisCardHStackView: UIStackView = UIStackView()
    let monthExpenseAnalysisCardView: AnalysisCardView = AnalysisCardView(title: NSLocalizedString("AnalysisView_MonthExpenseAnalysisCardView_Title", comment: "總支出"))
    let monthIncomeAnalysisCardView: AnalysisCardView = AnalysisCardView(title: NSLocalizedString("AnalysisView_MonthIncomeAnalysisCardView_Title", comment: "總收入"))
    let monthBalanceAnalysisCardView: AnalysisCardView = AnalysisCardView(title: NSLocalizedString("AnalysisView_MonthBalanceAnalysisCardView_Title", comment: "結餘"))
    
    private let mostCommonlyUsedPaymentMethodTitleLabel: UILabel = createLabel(title: NSLocalizedString("AnalysisView_MostCommonlyUsedPaymentMethodTitleLabel_Title", comment: "經常使用的支付方式"), font: AppConfig.Font.secondaryTitle.value)
    let mostCommonlyUsedPaymentMethod: UILabel = UILabel()
    
    private let mostCommonlyUsedTagTitleLabel: UILabel = createLabel(title: NSLocalizedString("AnalysisView_MostCommonlyUsedTagTitleLabel_Title", comment: "經常使用的標籤"), font: AppConfig.Font.secondaryTitle.value)
    let mostCommonlyUsedTag: UILabel = UILabel()
    
    // MARK: - 支出分析
    /*
     2️⃣ 支出分析

     📌 顯示方式：圖表 + 列表視圖（卡片顯示關鍵數據）

     📌 類別分析
         •    圓餅圖：顯示支出類別（食物、交通、娛樂等）占比
         •    文字標示：列出花費最多的前三大類別（例如：「食物 $5,000（40%）」）

     📌 標籤分析
         •    列表顯示標籤與支出金額
         •    例如：「早餐 $1,500（10%）」、「聚會 $2,000（15%）」

     📌 支付方式統計
         •    長條圖顯示各支付類別支出比例
         •    例如：「現金 50%、信用卡 30%、電子支付 20%」
     */
    private let expenseAnalysisTitleLabel: UILabel = createLabel(title: NSLocalizedString("AnalysisView_ExpenseAnalysisTitleLabel_Title", comment: "支出分析"), font: AppConfig.Font.secondaryTitle.value)
    private let byCategoryExpenseAnalysisTitleLabel: UILabel = createLabel(title: NSLocalizedString("AnalysisView_ByCategoryExpenseAnalysisTitleLabel_Title", comment: "按類別"), font: AppConfig.Font.quaternaryTitle.value)
    let expensePiechartView: PieChartView = PieChartView()
    private let expensePiechartDataNilLabel: UILabel = UILabel()
    
    private let byCategoryListExpenseAnalysisTitleLabel: UILabel = createLabel(title: NSLocalizedString("AnalysisView_ByCategoryListExpenseAnalysisTitleLabel_Title", comment: "各項類別支出列表"), font: AppConfig.Font.quaternaryTitle.value)
    private let categoryExpenseAnalysisHScrollView: UIScrollView = UIScrollView()
    private let categoryExpenseAnalysisHStackView: UIStackView = UIStackView()
    
    
    
    private let byPaymentMethodAnalysisTitleLabel: UILabel = createLabel(title: NSLocalizedString("AnalysisView_ByPaymentMethodAnalysisTitleLabel_Title", comment: "按支付方式"), font: AppConfig.Font.quaternaryTitle.value)
    let paymentMethodExpenseAnalysisBarChartView: BarChartView = BarChartView()
    
    // MARK: - 收入分析
    /*
    📌 顯示方式：長條圖 + 列表

    📌 收入來源
        •    長條圖：顯示不同收入來源（薪水、投資、紅包等）的占比
     */
    private let incomeAnalysisTitleLabel: UILabel = createLabel(title: NSLocalizedString("AnalysisView_IncomeAnalysisTitleLabel_Title", comment: "收入分析"), font: AppConfig.Font.secondaryTitle.value)
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setView()
        addSubviews()
        setConstranints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        wholePageScrollView.showsVerticalScrollIndicator = false
        wholePageScrollView.showsHorizontalScrollIndicator = false
        
        analysisCardHScrollView.showsHorizontalScrollIndicator = false
        analysisCardHStackView.axis = .horizontal
        analysisCardHStackView.distribution = .fillProportionally
        analysisCardHStackView.spacing = 10
        
        mostCommonlyUsedPaymentMethod.font = AppConfig.Font.quaternaryTitle.value
        mostCommonlyUsedPaymentMethod.textColor = .secondaryLabel
        
        mostCommonlyUsedTag.font = AppConfig.Font.quaternaryTitle.value
        mostCommonlyUsedTag.textColor = .secondaryLabel
        
        categoryExpenseAnalysisHScrollView.showsVerticalScrollIndicator = false
        categoryExpenseAnalysisHScrollView.showsHorizontalScrollIndicator = false
        
        categoryExpenseAnalysisHStackView.axis = .horizontal
        categoryExpenseAnalysisHStackView.spacing = 8
        
        expensePiechartDataNilLabel.text = NSLocalizedString("AnalysisView_ExpensePiechartDataNilLabel_Title", comment: "這個月還沒有任何記帳資料")
        expensePiechartDataNilLabel.font = AppConfig.Font.quaternaryTitle.value
        expensePiechartDataNilLabel.textColor = .secondaryLabel
    }
    
    private func addSubviews() {
        wholePageScrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wholePageScrollView)
        
        wholePageContentView.translatesAutoresizingMaskIntoConstraints = false
        wholePageScrollView.addSubview(wholePageContentView)
        
        [analysisViewTitleLabel, yearMonthPicker, analysisSummaryLabel, analysisCardHScrollView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            wholePageContentView.addSubview(view)
        }
        
        analysisCardHStackView.translatesAutoresizingMaskIntoConstraints = false
        analysisCardHScrollView.addSubview(analysisCardHStackView)
        
        [monthExpenseAnalysisCardView, monthIncomeAnalysisCardView, monthBalanceAnalysisCardView].forEach { view in
            analysisCardHStackView.addArrangedSubview(view)
        }
        [mostCommonlyUsedPaymentMethodTitleLabel, mostCommonlyUsedPaymentMethod, mostCommonlyUsedTagTitleLabel, mostCommonlyUsedTag].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            wholePageContentView.addSubview(view)
        }
        
        expenseAnalysisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        wholePageContentView.addSubview(expenseAnalysisTitleLabel)
        
        byCategoryExpenseAnalysisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        wholePageContentView.addSubview(byCategoryExpenseAnalysisTitleLabel)
        
        expensePiechartView.translatesAutoresizingMaskIntoConstraints = false
        wholePageContentView.addSubview(expensePiechartView)
        
        byCategoryListExpenseAnalysisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        wholePageContentView.addSubview(byCategoryListExpenseAnalysisTitleLabel)
        
        categoryExpenseAnalysisHScrollView.translatesAutoresizingMaskIntoConstraints = false
        wholePageContentView.addSubview(categoryExpenseAnalysisHScrollView)
        
        categoryExpenseAnalysisHStackView.translatesAutoresizingMaskIntoConstraints = false
        categoryExpenseAnalysisHScrollView.addSubview(categoryExpenseAnalysisHStackView)
        
        byPaymentMethodAnalysisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        wholePageContentView.addSubview(byPaymentMethodAnalysisTitleLabel)
        
        paymentMethodExpenseAnalysisBarChartView.translatesAutoresizingMaskIntoConstraints = false
        wholePageContentView.addSubview(paymentMethodExpenseAnalysisBarChartView)
    }
    
    private func setConstranints() {
        let layoutConstraints: [NSLayoutConstraint] = [
            wholePageScrollView.topAnchor.constraint(equalTo: topAnchor),
            wholePageScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wholePageScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            wholePageScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            wholePageScrollView.heightAnchor.constraint(equalTo: heightAnchor),
            
//            wholePageContentView.heightAnchor.constraint(greaterThanOrEqualTo: wholePageScrollView.heightAnchor),
            wholePageContentView.topAnchor.constraint(equalTo: wholePageScrollView.topAnchor),
            wholePageContentView.leadingAnchor.constraint(equalTo: wholePageScrollView.leadingAnchor),
            wholePageContentView.trailingAnchor.constraint(equalTo: wholePageScrollView.trailingAnchor),
            wholePageContentView.bottomAnchor.constraint(equalTo: wholePageScrollView.bottomAnchor),
            wholePageContentView.widthAnchor.constraint(equalTo: wholePageScrollView.widthAnchor),
            
            analysisViewTitleLabel.topAnchor.constraint(equalTo: wholePageContentView.topAnchor, constant: 10),
            analysisViewTitleLabel.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            yearMonthPicker.topAnchor.constraint(greaterThanOrEqualTo: wholePageContentView.topAnchor, constant: 10),
            yearMonthPicker.leadingAnchor.constraint(greaterThanOrEqualTo: analysisViewTitleLabel.trailingAnchor),
            yearMonthPicker.trailingAnchor.constraint(equalTo: wholePageContentView.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            yearMonthPicker.bottomAnchor.constraint(equalTo: analysisViewTitleLabel.bottomAnchor),
            
            analysisSummaryLabel.topAnchor.constraint(equalTo: analysisViewTitleLabel.bottomAnchor, constant: 15),
            analysisSummaryLabel.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            analysisCardHScrollView.topAnchor.constraint(equalTo: analysisSummaryLabel.bottomAnchor, constant: 5),
            analysisCardHScrollView.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            analysisCardHScrollView.trailingAnchor.constraint(equalTo: wholePageContentView.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            analysisCardHScrollView.heightAnchor.constraint(equalToConstant: 100),
            
            analysisCardHStackView.leadingAnchor.constraint(equalTo: analysisCardHScrollView.leadingAnchor),
            analysisCardHStackView.heightAnchor.constraint(equalTo: analysisCardHScrollView.heightAnchor),
            analysisCardHStackView.topAnchor.constraint(equalTo: analysisCardHScrollView.topAnchor),
            analysisCardHStackView.bottomAnchor.constraint(equalTo: analysisCardHScrollView.bottomAnchor),
            analysisCardHStackView.trailingAnchor.constraint(equalTo: analysisCardHScrollView.trailingAnchor),
            
            mostCommonlyUsedPaymentMethodTitleLabel.topAnchor.constraint(equalTo: analysisCardHScrollView.bottomAnchor, constant: 15),
            mostCommonlyUsedPaymentMethodTitleLabel.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            mostCommonlyUsedPaymentMethod.topAnchor.constraint(equalTo: mostCommonlyUsedPaymentMethodTitleLabel.bottomAnchor, constant: 5),
            mostCommonlyUsedPaymentMethod.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            mostCommonlyUsedTagTitleLabel.topAnchor.constraint(equalTo: mostCommonlyUsedPaymentMethod.bottomAnchor, constant: 15),
            mostCommonlyUsedTagTitleLabel.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            mostCommonlyUsedTag.topAnchor.constraint(equalTo: mostCommonlyUsedTagTitleLabel.bottomAnchor, constant: 5),
            mostCommonlyUsedTag.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            expenseAnalysisTitleLabel.topAnchor.constraint(equalTo: mostCommonlyUsedTag.bottomAnchor, constant: 15),
            expenseAnalysisTitleLabel.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            byCategoryExpenseAnalysisTitleLabel.topAnchor.constraint(equalTo: expenseAnalysisTitleLabel.bottomAnchor, constant: 5),
            byCategoryExpenseAnalysisTitleLabel.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            byCategoryExpenseAnalysisTitleLabel.trailingAnchor.constraint(equalTo: expenseAnalysisTitleLabel.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            
            expensePiechartView.topAnchor.constraint(equalTo: byCategoryExpenseAnalysisTitleLabel.bottomAnchor, constant: 5),
            expensePiechartView.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            expensePiechartView.trailingAnchor.constraint(equalTo: wholePageContentView.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            expensePiechartView.heightAnchor.constraint(equalToConstant: 300),
            expensePiechartView.widthAnchor.constraint(equalTo: wholePageContentView.widthAnchor, constant: -20),
            
            byCategoryListExpenseAnalysisTitleLabel.topAnchor.constraint(equalTo: expensePiechartView.bottomAnchor, constant: 5),
            byCategoryListExpenseAnalysisTitleLabel.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            byCategoryListExpenseAnalysisTitleLabel.trailingAnchor.constraint(equalTo: expenseAnalysisTitleLabel.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            
            categoryExpenseAnalysisHScrollView.topAnchor.constraint(equalTo: byCategoryListExpenseAnalysisTitleLabel.bottomAnchor, constant: 5),
            categoryExpenseAnalysisHScrollView.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            categoryExpenseAnalysisHScrollView.trailingAnchor.constraint(equalTo: wholePageContentView.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            categoryExpenseAnalysisHScrollView.heightAnchor.constraint(equalTo: categoryExpenseAnalysisHStackView.heightAnchor),
            
            categoryExpenseAnalysisHStackView.heightAnchor.constraint(equalToConstant: 40),
            categoryExpenseAnalysisHStackView.leadingAnchor.constraint(equalTo: categoryExpenseAnalysisHScrollView.leadingAnchor),
            categoryExpenseAnalysisHStackView.trailingAnchor.constraint(equalTo: categoryExpenseAnalysisHScrollView.trailingAnchor),
//            tagExpenseAnalysisHStackView.widthAnchor.constraint(equalTo: tagExpenseAnalysisHScrollView.widthAnchor),
            categoryExpenseAnalysisHStackView.topAnchor.constraint(equalTo: categoryExpenseAnalysisHScrollView.topAnchor),
            categoryExpenseAnalysisHStackView.bottomAnchor.constraint(equalTo: categoryExpenseAnalysisHScrollView.bottomAnchor),
            
            byPaymentMethodAnalysisTitleLabel.topAnchor.constraint(equalTo: categoryExpenseAnalysisHScrollView.bottomAnchor, constant: 5),
            byPaymentMethodAnalysisTitleLabel.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            paymentMethodExpenseAnalysisBarChartView.topAnchor.constraint(equalTo: byPaymentMethodAnalysisTitleLabel.bottomAnchor, constant: 5),
            paymentMethodExpenseAnalysisBarChartView.leadingAnchor.constraint(equalTo: wholePageContentView.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            paymentMethodExpenseAnalysisBarChartView.trailingAnchor.constraint(equalTo: wholePageContentView.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            paymentMethodExpenseAnalysisBarChartView.heightAnchor.constraint(equalToConstant: 300),
            
            paymentMethodExpenseAnalysisBarChartView.bottomAnchor.constraint(equalTo: wholePageContentView.bottomAnchor, constant: -20),
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func configPieChart(data: [PieChartDataEntry]) {
        
        // 設置數據集
        let dataSet = PieChartDataSet(entries: data, label: NSLocalizedString("AnalysisView_ExpensePiechartView_PieChartDataSet_Title", comment: "支出類別"))
        let colors: [UIColor] = (0..<data.count).map { i in
            UIColor(hue: CGFloat(i) / CGFloat(data.count), saturation: 0.8, brightness: 0.9, alpha: 1.0)
        }
        dataSet.colors = colors
        dataSet.yValuePosition = .outsideSlice  // 數值顯示在圓餅外側
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        // PieChartData
        let data = PieChartData(dataSet: dataSet)
        expensePiechartView.data = data
        
        // 圖表配置
        expensePiechartView.usePercentValuesEnabled = true // 顯示百分比
//        expensePiechartView.holeColor = UIColor.white // 圓心顏色
//        expensePiechartView.drawSlicesUnderHoleEnabled = true // 是否顯示圓心下方的扇形
        expensePiechartView.legend.form = .line // 圖例樣式
        
    }
    
    func configCategoryExpenseList(categoryExpenseDictionary: [UUID: Double]) {
        for category in categoryExpenseDictionary.sorted(by: { $0.value > $1.value }) {
            let tagExpenseLabel: UILabel = UILabel()
            guard let expense = AppFormatter.shared.currencyNumberFormatter.string(from: NSNumber(value: category.value)) else { continue }
            tagExpenseLabel.text = "\(NSLocalizedString(CoreDataInitializer.shared.transactionCategory[category.key]!, comment: "")): \(expense)"
            tagExpenseLabel.font = AppConfig.Font.content.value
            tagExpenseLabel.textColor = .secondaryLabel
            categoryExpenseAnalysisHStackView.addArrangedSubview(tagExpenseLabel)
        }
        self.layoutIfNeeded()
        
    }
    
    func configPaymentMethodBarChart(paymentMethodExpenseDictionary: [UUID: Double]) {
//        let values: [Double] = [10, 20, 30, 15, 25]
//        let labels: [String] = ["一月", "二月", "三月", "四月", "五月"]

        var dataEntries: [BarChartDataEntry] = []
        for (index, key) in paymentMethodExpenseDictionary.keys.sorted(by: <).enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: paymentMethodExpenseDictionary[key]!)
            dataEntries.append(entry)
        }

        let dataSet = BarChartDataSet(entries: dataEntries, label: NSLocalizedString("AnalysisView_PaymentMethodExpenseAnalysisBarChartView_BarChartDataSet_Title", comment: "收入"))
        dataSet.colors = [UIColor.systemBlue]  // 設定顏色
        dataSet.valueTextColor = .black  // 數值顏色
        dataSet.valueFont = .systemFont(ofSize: 10)

        let data = BarChartData(dataSet: dataSet)
        paymentMethodExpenseAnalysisBarChartView.data = data

        // 設定 X 軸標籤
        print(paymentMethodExpenseDictionary)
        print(CoreDataInitializer.shared.transactionCategory)
        paymentMethodExpenseAnalysisBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: paymentMethodExpenseDictionary.keys.sorted(by: <).map { NSLocalizedString(CoreDataInitializer.shared.transactionPaymentMethod[$0]!, comment: "")})
        paymentMethodExpenseAnalysisBarChartView.xAxis.labelPosition = .bottom
        paymentMethodExpenseAnalysisBarChartView.xAxis.granularity = 1
    }
    
    func expensePiechartSetting(empty: Bool) {
        if empty {
            expensePiechartDataNilLabel.translatesAutoresizingMaskIntoConstraints = false
            expensePiechartView.addSubview(expensePiechartDataNilLabel)
            NSLayoutConstraint.activate([
                expensePiechartDataNilLabel.centerXAnchor.constraint(equalTo: expensePiechartView.centerXAnchor),
                expensePiechartDataNilLabel.centerYAnchor.constraint(equalTo: expensePiechartView.centerYAnchor)
                ])
        } else {
            expensePiechartDataNilLabel.removeFromSuperview()
        }
    }
    
    private static func createLabel(title: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = font
        return label
    }
}

//
//  HomeView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/18.
//

import UIKit

class HomeView: UIView {
    
    /// summary
    private lazy var summaryLabel: UILabel = UILabel()
    lazy var segementControl: UISegmentedControl = UISegmentedControl()
    private lazy var horizonStack: UIStackView = UIStackView()
    lazy var totalSpent: MoneyBalanceView = MoneyBalanceView(itemLabelText: "總花費")
    lazy var totalIncome: MoneyBalanceView = MoneyBalanceView(itemLabelText: "總收入")
    lazy var viewDetailButton: UIButton = UIButton(type: .system)
    private var summaryBottomAnchor: NSLayoutYAxisAnchor {
        get {
            viewDetailButton.bottomAnchor
        }
    }
    
    /// chart
    private var chartLabel: UILabel = UILabel()
    private var chartScrollView: UIScrollView = UIScrollView()
    var transactionLineChartView: TransactionLineChartView = TransactionLineChartView()
    var chartView: [UIView] = [] // 0: 長條圖, 1: 圓餅圖, 2: 趨勢圖
    private var chartPageControl: UIPageControl = UIPageControl()
    
    /// fast navigate button
    private var fastNavigateLabel: UILabel = UILabel()
    private let fastNavigateButtonStackView: UIStackView = UIStackView()
    private var detailButton: UIButton = UIButton(configuration: .tinted())
    private var setBudgetButton: UIButton = UIButton(configuration: .tinted())
    private var setNotificationButton: UIButton = UIButton(configuration: .tinted())
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        horizonStack.addArrangedSubview(totalSpent)
        horizonStack.addArrangedSubview(totalIncome)
        chartView = [transactionLineChartView, UIView(), UIView()]
        chartView.forEach {
            chartScrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        fastNavigateButtonStackView.addArrangedSubview(detailButton)
        fastNavigateButtonStackView.addArrangedSubview(setBudgetButton)
        fastNavigateButtonStackView.addArrangedSubview(setNotificationButton)
        [summaryLabel, segementControl, horizonStack, viewDetailButton, chartLabel, chartScrollView, chartPageControl, fastNavigateLabel, fastNavigateButtonStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25),
            summaryLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            segementControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            segementControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25),
            
            horizonStack.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 15),
            horizonStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            horizonStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            horizonStack.heightAnchor.constraint(equalToConstant: 100),
            
            viewDetailButton.topAnchor.constraint(equalTo: totalSpent.bottomAnchor, constant: 15),
            viewDetailButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            viewDetailButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            viewDetailButton.heightAnchor.constraint(equalToConstant: 42),
            
            chartLabel.topAnchor.constraint(equalTo: summaryBottomAnchor, constant: 25),
            chartLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            chartScrollView.topAnchor.constraint(equalTo: chartLabel.bottomAnchor, constant: 15),
            chartScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            chartScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            chartScrollView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            chartScrollView.heightAnchor.constraint(equalToConstant: 250),
            
            chartView.last!.trailingAnchor.constraint(equalTo: chartScrollView.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            
            chartPageControl.topAnchor.constraint(equalTo: chartScrollView.bottomAnchor, constant: 5),
            chartPageControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            chartPageControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
            
            fastNavigateLabel.topAnchor.constraint(equalTo: chartPageControl.bottomAnchor, constant: 25),
            fastNavigateLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            
            fastNavigateButtonStackView.topAnchor.constraint(equalTo: fastNavigateLabel.bottomAnchor, constant: 20),
            fastNavigateButtonStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value),
            fastNavigateButtonStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value),
        ])
        
        for i in 0..<chartView.count {
            let chart = chartView[i]
            if i == 0 {
                chart.leadingAnchor.constraint(equalTo: chartScrollView.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
            } else {
                chart.leadingAnchor.constraint(equalTo: chartView[i-1].trailingAnchor, constant: AppConfig.SideSpace.standard.value * 2).isActive = true
            }
            chart.topAnchor.constraint(equalTo: chartScrollView.topAnchor).isActive = true
            chart.bottomAnchor.constraint(equalTo: chartScrollView.bottomAnchor).isActive = true
            chart.heightAnchor.constraint(equalTo: chartScrollView.heightAnchor).isActive = true
            chart.widthAnchor.constraint(equalTo: chartScrollView.widthAnchor, constant: -AppConfig.SideSpace.standard.value * 2).isActive = true
        }
    }
    
    private func setUpViews() {
        // summary label
        summaryLabel.text = "總覽"
        summaryLabel.font = AppConfig.Font.title.value
        
        // segement control
//        segementControl.selectedSegmentIndex = 0
        
        // summary stack
        horizonStack.axis = .horizontal
        horizonStack.distribution = .fillEqually
        horizonStack.spacing = 10
        
        // view detail button
        viewDetailButton.setTitle("瀏覽花費收入詳細資料", for: .normal)
        viewDetailButton.titleLabel?.font = AppConfig.Font.secondaryTitle.value
        viewDetailButton.tintColor = .white
        viewDetailButton.backgroundColor = .black
        viewDetailButton.layer.cornerRadius = 5
        viewDetailButton.clipsToBounds = true
        
        // chart label
        chartLabel.text = "圖表"
        chartLabel.font = AppConfig.Font.title.value
        
        // chart scroll view
        chartScrollView.showsHorizontalScrollIndicator = false
        chartScrollView.showsVerticalScrollIndicator = false
        chartScrollView.isPagingEnabled = true
        
        // chart
        for i in 0..<chartView.count {
            let chart = chartView[i]
            chart.layer.cornerRadius = 10
            chart.layer.borderWidth = 1
            chart.layer.borderColor = UIColor.black.cgColor
        }
        
        // chart page control
        chartPageControl.currentPage = 0
        chartPageControl.numberOfPages = chartView.count
        chartPageControl.currentPageIndicatorTintColor = .white
        chartPageControl.pageIndicatorTintColor = .gray
        chartPageControl.backgroundStyle = .automatic
        chartPageControl.layer.cornerRadius = 5
        chartPageControl.clipsToBounds = true
        chartPageControl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.1)
        
        // fast navigate label
        fastNavigateLabel.text = "快速操作"
        fastNavigateLabel.font = AppConfig.Font.title.value
        
        // fast navigate button stack view
        fastNavigateButtonStackView.axis = .horizontal
        fastNavigateButtonStackView.distribution = .fillEqually
        fastNavigateButtonStackView.spacing = 10
        
        // detail button
        detailButton.setTitle("詳細報表", for: .normal)
        detailButton.tintColor = .black
        
        // set budget button
        setBudgetButton.setTitle("設定預算", for: .normal)
        setBudgetButton.tintColor = .black
        
        // set notification button
        setNotificationButton.setTitle("設定提醒", for: .normal)
        setNotificationButton.tintColor = .black
    }
}


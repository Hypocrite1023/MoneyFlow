//
//  HomeView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/18.
//

import UIKit

class HomeView: UIView {
    
    /// summary
    private var summaryLabel: UILabel = UILabel()
    private var segementControl: UISegmentedControl = UISegmentedControl(items: ["今天", "本週", "本月"])
    private let horizonStack: UIStackView = UIStackView()
    private var totalSpent: MoneyBalanceView = MoneyBalanceView(itemLabelText: "總花費", balance: 5000)
    private var totalIncome: MoneyBalanceView = MoneyBalanceView(itemLabelText: "總收入", balance: 10000)
    private var viewDetailButton: UIButton = UIButton(type: .system)
    private var summaryBottomAnchor: NSLayoutYAxisAnchor {
        get {
            viewDetailButton.bottomAnchor
        }
    }
    
    /// chart
    private var chartLabel: UILabel = UILabel()
    private var chartScrollView: UIScrollView = UIScrollView()
    private var chartView: [UIView] = [UIView(), UIView(), UIView()] // 0: 長條圖, 1: 圓餅圖, 2: 趨勢圖
    private var chartPageControl: UIPageControl = UIPageControl()
    
    /// fast navigate button
    private var fastNavigateLabel: UILabel = UILabel()
    private let fastNavigateButtonStackView: UIStackView = UIStackView()
    private var detailButton: UIButton = UIButton(configuration: .tinted())
    private var setBudgetButton: UIButton = UIButton(configuration: .tinted())
    private var setNotificationButton: UIButton = UIButton(configuration: .tinted())
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        setupSummaryView()
        setChartView()
        setFastNavigateView()
    }
    
    private func setupSummaryView() {
        // summary label
        self.addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.text = "總覽"
        summaryLabel.font = AppConfig.Font.title.value
        
        // segement control
        self.addSubview(segementControl)
        segementControl.translatesAutoresizingMaskIntoConstraints = false
        
        // summary stack
        self.addSubview(horizonStack)
        horizonStack.translatesAutoresizingMaskIntoConstraints = false
        horizonStack.addArrangedSubview(totalSpent)
        horizonStack.addArrangedSubview(totalIncome)
        horizonStack.axis = .horizontal
        horizonStack.distribution = .fillEqually
        horizonStack.spacing = 10
        
        // view detail button
        self.addSubview(viewDetailButton)
        viewDetailButton.translatesAutoresizingMaskIntoConstraints = false
        viewDetailButton.setTitle("瀏覽花費收入詳細資料", for: .normal)
        viewDetailButton.titleLabel?.font = AppConfig.Font.secondaryTitle.value
        viewDetailButton.tintColor = .white
        viewDetailButton.backgroundColor = .black
//        viewDetailButton.layer.borderColor = UIColor.black.cgColor
//        viewDetailButton.layer.borderWidth = 1
        viewDetailButton.layer.cornerRadius = 5
        viewDetailButton.clipsToBounds = true
        
        // constraint
        setupSummaryViewConstraints()
    }
    
    private func setupSummaryViewConstraints() {
        summaryLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        summaryLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        
        segementControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        segementControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        
        horizonStack.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 15).isActive = true
        horizonStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        horizonStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        horizonStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        viewDetailButton.topAnchor.constraint(equalTo: totalSpent.bottomAnchor, constant: 15).isActive = true
        viewDetailButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        viewDetailButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        viewDetailButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
    }
    
    
    private func setChartView() {
        // chart label
        self.addSubview(chartLabel)
        chartLabel.translatesAutoresizingMaskIntoConstraints = false
        chartLabel.text = "圖表"
        chartLabel.font = AppConfig.Font.title.value
        
        // chart scroll view
        self.addSubview(chartScrollView)
        chartScrollView.translatesAutoresizingMaskIntoConstraints = false
        chartScrollView.showsHorizontalScrollIndicator = false
        chartScrollView.showsVerticalScrollIndicator = false
        chartScrollView.isPagingEnabled = true
        chartScrollView.delegate = self
        
        // chart
        for i in 0..<chartView.count {
            let chart = chartView[i]
            chartScrollView.addSubview(chart)
            chart.translatesAutoresizingMaskIntoConstraints = false
            chart.layer.cornerRadius = 10
            chart.layer.borderWidth = 1
            chart.layer.borderColor = UIColor.black.cgColor
        }
        
        // chart page control
        self.addSubview(chartPageControl)
        chartPageControl.translatesAutoresizingMaskIntoConstraints = false
        chartPageControl.currentPage = 0
        chartPageControl.numberOfPages = chartView.count
        chartPageControl.currentPageIndicatorTintColor = .white
        chartPageControl.pageIndicatorTintColor = .gray
        chartPageControl.backgroundStyle = .automatic
        chartPageControl.layer.cornerRadius = 5
        chartPageControl.clipsToBounds = true
        chartPageControl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.1)
        
        // constraints
        setupChartViewConstraints()
    }
    
    private func setupChartViewConstraints() {
        chartLabel.topAnchor.constraint(equalTo: summaryBottomAnchor, constant: 25).isActive = true
        chartLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        
        chartScrollView.topAnchor.constraint(equalTo: chartLabel.bottomAnchor, constant: 15).isActive = true
        chartScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        chartScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        chartScrollView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor).isActive = true
        chartScrollView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
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
        chartView.last!.trailingAnchor.constraint(equalTo: chartScrollView.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
        
        chartPageControl.topAnchor.constraint(equalTo: chartScrollView.bottomAnchor, constant: 5).isActive = true
//        chartPageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        chartPageControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        chartPageControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
    }
    
    private func setFastNavigateView() {
        // fast navigate label
        self.addSubview(fastNavigateLabel)
        fastNavigateLabel.translatesAutoresizingMaskIntoConstraints = false
        fastNavigateLabel.text = "快速操作"
        fastNavigateLabel.font = AppConfig.Font.title.value
        
        // fast navigate button stack view
        self.addSubview(fastNavigateButtonStackView)
        fastNavigateButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        fastNavigateButtonStackView.addArrangedSubview(detailButton)
        fastNavigateButtonStackView.addArrangedSubview(setBudgetButton)
        fastNavigateButtonStackView.addArrangedSubview(setNotificationButton)
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
        
        // constraints
        setupFastNavigateViewConstraints()
    }
    
    private func setupFastNavigateViewConstraints() {
        fastNavigateLabel.topAnchor.constraint(equalTo: chartPageControl.bottomAnchor, constant: 25).isActive = true
        fastNavigateLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        
        fastNavigateButtonStackView.topAnchor.constraint(equalTo: fastNavigateLabel.bottomAnchor, constant: 20).isActive = true
        fastNavigateButtonStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: AppConfig.SideSpace.standard.value).isActive = true
        fastNavigateButtonStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -AppConfig.SideSpace.standard.value).isActive = true
    }
}

extension HomeView: UIScrollViewDelegate {
    
}

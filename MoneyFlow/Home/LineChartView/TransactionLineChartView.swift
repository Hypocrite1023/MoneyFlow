//
//  TransactionLineChartView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/15.
//

import UIKit
import DGCharts

class TransactionLineChartView: UIView {
    
    var lineChartView: LineChartView = LineChartView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
        // 初始化 LineChartView
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineChartView)
        
        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            lineChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            lineChartView.topAnchor.constraint(equalTo: topAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        setupChartData()
    }
    
    private func setupChartData() {
        
        // 自訂 X 軸的標籤
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelRotationAngle = 45
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        
        // 其他樣式設定
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.rightAxis.enabled = false // 隱藏右邊的 Y 軸
        lineChartView.leftAxis.enabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.dragEnabled = false
        
    }
}

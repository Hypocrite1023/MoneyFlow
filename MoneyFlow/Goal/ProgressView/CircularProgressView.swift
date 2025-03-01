//
//  GoalProgressView.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/17.
//

import UIKit

class CircularProgressView: UIView {

    var backLayer: CAShapeLayer = CAShapeLayer()
    var progressLayer: CAShapeLayer = CAShapeLayer()
    var valueLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setProgress()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 確保 bounds 已經有正確的大小
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: min(bounds.width, bounds.height) / 2 - 10,
            startAngle: -.pi / 2,
            endAngle: .pi * 3 / 2,
            clockwise: true
        )
        
        backLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
        
        valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setProgress() {
        
        backLayer.strokeColor = UIColor.lightGray.cgColor
        backLayer.lineWidth = 20
        backLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(backLayer)
        
        progressLayer.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        progressLayer.lineWidth = 18
        progressLayer.lineCap = .round
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    func animateProgress(duration: TimeInterval, toValue: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressLayer.strokeEnd = toValue
        progressLayer.add(animation, forKey: "progressAnimation")
    }
}

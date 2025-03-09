//
//  AppNumberFormatter.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/23.
//

import Foundation

public class AppFormatter {
    static let shared = AppFormatter()
    private init() {}
    
    lazy var currencyNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
}

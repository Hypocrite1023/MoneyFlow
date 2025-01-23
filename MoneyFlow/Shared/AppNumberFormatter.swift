//
//  AppNumberFormatter.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/23.
//

import Foundation

public class AppNumberFormatter {
    static let shared = AppNumberFormatter()
    private init() {}
    
    lazy var currencyNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
}

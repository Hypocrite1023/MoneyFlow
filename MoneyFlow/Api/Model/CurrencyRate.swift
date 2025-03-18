//
//  CurrencyRate.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/18.
//

import Foundation

struct CurrencyRate: Decodable {
    let response: Response
    struct Response: Decodable {
        let date: String
        let base: String
        let rates: [String: Double]
    }
}

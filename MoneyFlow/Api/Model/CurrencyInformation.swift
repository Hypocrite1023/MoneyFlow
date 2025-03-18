//
//  Currency.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/16.
//

import Foundation

struct CurrencyInformation: Decodable {
    
    let response: [Information]
    
    
    struct Information: Decodable {
//        let code: String
//        let decimalMark: String
        let id: Int
        let name: String //
//        let precision: Int
        let shortCode: String //
//        let subunit: Int
        let symbol: String //
//        let symbolFirst: Bool
//        let thousandsSeparator: String
        
        enum CodingKeys: String, CodingKey {
//            case code
//            case decimalMark = "decimal_mark"
            case id
            case name
//            case precision
            case shortCode = "short_code"
//            case subunit
            case symbol
//            case symbolFirst = "symbol_first"
//            case thousandsSeparator = "thousands_separator"
        }
    }
    
}

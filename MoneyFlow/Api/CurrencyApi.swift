//
//  Currency+Api.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/15.
//

import Foundation

// https://api.currencybeacon.com/v1

class CurrencyApi {
    
    enum Keys {
        static let currencyApiKey = "Currencybeacon_API_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let apiToken: String = {
        guard let token = infoDictionary[Keys.currencyApiKey] as? String else {
            fatalError("Currencybeacon API Key not found")
        }
        return token
    }()
}

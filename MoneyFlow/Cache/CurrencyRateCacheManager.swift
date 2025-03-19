//
//  CurrencyRateCacheManager.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/19.
//

import Foundation

class CurrencyRateCacheManager {
    static let shared = CurrencyRateCacheManager()
    
    private init() {}
    
    private let cache = NSCache<NSString, CurrencyRatePair>()
    
    func setCurrencyRatePair(_ pair: CurrencyRatePair, forDate key: String) {
        cache.setObject(pair, forKey: key as NSString)
    }
    
    func getCurrencyRatePair(forDate key: String) -> CurrencyRatePair? {
        cache.object(forKey: key as NSString)
    }
}

class CurrencyRatePair: Decodable {
    let rates: [String: Double?]
    let base: String
    
    init(rates: [String: Double?], base: String) {
        self.rates = rates
        self.base = base
    }
}

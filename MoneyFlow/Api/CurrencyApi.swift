//
//  Currency+Api.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/15.
//

import Foundation
import Combine

// https://api.currencybeacon.com/v1

/*
 SERVICE    API ENDPOINT    DESCRIPTION
 
 
 
 timeseries    https://api.currencybeacon.com/v1/timeseries
    base - Required - The base currency you would like to use for your rates.
    start_date - Required - The start date for the time series you would like to access (Format: YYYY-MM-DD).
    end_date - Required - The end date for the time series you would like to access (Format: YYYY-MM-DD).
    symbols - A list of currencies you would like to see the rates for. You can view all supported currencies here.
    
    If you have the Startup or Professional plan, you have access to the timeseries endpoint. This lets you request historical exchange rates for a given time period. To use this endpoint, specify both start_date and end_date to define the date range.
 
 convert    https://api.currencybeacon.com/v1/convert
    from - Required - The base currency you would like to convert from.
    to - Required - The currency you would like to convert to.
    amount - Required - The amount to convert.
 
    Using the convert endpoint, you can request our API to perform a single currency conversion. Simply specify the from currency, the to currency, and the amount to be converted.
 
 HTTP Response Codes
    200    Success. Everything went smoothly.
    401    Unauthorized. Missing or incorrect API token in the header.
    422    Unprocessable Entity. Something isn’t quite right (e.g., malformed JSON or incorrect fields). The response body contains JSON with an API error code and message detailing what went wrong.
    500    Internal Server Error. An issue occurred with CurrencyBeacon’s servers while processing your request. In most cases, the message is lost during the process, but we are notified so we can investigate the problem.
    503    Service Unavailable. During planned service outages, CurrencyBeacon API services will return this HTTP response with an associated JSON body.
    429    Too many requests. API rate limits have been reached.
 
 API Error Codes
     600    Maintenance - The CurrencyBeacon API is offline for maintenance.
     601    Unauthorized. Missing or incorrect API token.
     602    Invalid query parameters.
     603    Authorized Subscription level required.
 */

class CurrencyApi {
    
    enum Keys {
        static let currencyApiKey = "Currencybeacon_API_KEY"
    }
    
    enum NetworkError: Error {
        case invalidURL
        case networkFailure(Error)
        case invalidResponse(Int)
        case decodingError(Error)
        case apiRateLimitsReached
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
    
    static let shared = CurrencyApi()
    var supportedCurrencies: [CurrencyInformation.Information] = []
    var cancellable: AnyCancellable?
    
    private init() {}
    
    func fetchData<T: Decodable>(fromURL: String) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: fromURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ (data, response) in
                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    if response.statusCode == 429 {
                        throw NetworkError.apiRateLimitsReached
                    } else {
                        throw NetworkError.invalidResponse(response.statusCode)
                    }
                }
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(decodingError)
                } else {
                    return NetworkError.networkFailure(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// currencies    https://api.currencybeacon.com/v1/currencies
    /// - `type` - Required - The type of currencies, either `fiat` or `crypto`.
    ///
    /// This endpoint gives you access to all supported currencies, including each currency’s name and a list of the countries that use it. You can view all supported currencies here.
    func fetchSupportedCurrencies<T: Decodable>() -> AnyPublisher<T, NetworkError> {
        let url = "https://api.currencybeacon.com/v1/currencies?api_key=\(CurrencyApi.apiToken)&type=fiat"
        return fetchData(fromURL: url)
    }
    
    
    /// latest    https://api.currencybeacon.com/v1/latest
    ///
    /// - `base`:  Required - The base currency you would like to use for your rates.
    ///
    /// - `symbols`:  A list of currencies you would like to retrieve rates for.
    ///
    /// This endpoint provides real-time exchange rates for all supported currencies. Please note these are mid-market rates; margins are typically added by users before consumers receive them. The endpoint requires the base currency and a list of symbols to be returned. You can view all supported currencies here.
    func fetchCurrenciesLatest<T: Decodable>(base: String) -> AnyPublisher<T, NetworkError> {
        // https://api.currencybeacon.com/v1/latest?api_key=YOUR_API_KEY
        let url = "https://api.currencybeacon.com/v1/latest?api_key=\(CurrencyApi.apiToken)&base=\(base)"
        return fetchData(fromURL: url)
    }
    
    /// historical    https://api.currencybeacon.com/v1/historical
    ///
    /// - base - Required - The base currency you would like to use for your rates.
    /// - date - Required - The historical date you would like to access (Format: YYYY-MM-DD).
    /// - symbols - A list of currencies you would like to see rates for. You can view all supported currencies here.
    ///
    ///   This endpoint provides historical exchange rate data for past dates going back to 1996. Simply attach the date parameter with a valid date to the API’s historical endpoint. You can also specify a base currency and a list of symbols to be returned. View all supported currencies here.
    func fetchCurrenciesHistorical(base: String, date: String) -> AnyPublisher<CurrencyRatePair, NetworkError> {
        let ensureSupportedCurrenciesPublisher: AnyPublisher<[CurrencyInformation.Information], Never>
        if supportedCurrencies.isEmpty {
            ensureSupportedCurrenciesPublisher = fetchSupportedCurrencies()
                .map { value -> [CurrencyInformation.Information] in
                    let currencyInfo: CurrencyInformation = value
                    self.supportedCurrencies = currencyInfo.response
                    return currencyInfo.response
                }
                .replaceError(with: []) // 如果失敗，就不做任何事
                .eraseToAnyPublisher()
        } else {
            ensureSupportedCurrenciesPublisher = Just(supportedCurrencies)
                .eraseToAnyPublisher()
        }
        if let cachedResponse = CurrencyRateCacheManager.shared.getCurrencyRatePair(forDate: date) {
            print("cache有值", date)
            return Just(cachedResponse)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        return ensureSupportedCurrenciesPublisher.flatMap { supportedCurrencies -> AnyPublisher<CurrencyRatePair, NetworkError> in
            let url = "https://api.currencybeacon.com/v1/historical?api_key=\(CurrencyApi.apiToken)&base=\(base)&date=\(date)&symbols=\(supportedCurrencies.map(\.shortCode).joined(separator: ","))"
//            print(url)
            return self.fetchData(fromURL: url)
        }
        .eraseToAnyPublisher()
        
    }
    
    func fetchCurrenciesRate(base: String, dates: [String]) -> AnyPublisher<[String: CurrencyRatePair], Never> {
        let publishers = dates.map { date in
            fetchCurrenciesHistorical(base: base, date: date)
                .map {
//                    let currencyInfo: CurrencyRate = $0
                    return (date, $0)
                }
                .replaceError(with: (String(), CurrencyRatePair(rates: [:], base: String())))
                .eraseToAnyPublisher()
                
        }
        
        return Publishers.MergeMany(publishers)
            .map { (date, rate) in
                CurrencyRateCacheManager.shared.setCurrencyRatePair(rate, forDate: date)
                return (date, rate)
            }
            .collect()  // 等所有請求完成
            .map { results in
                
                Dictionary(uniqueKeysWithValues: results) // 轉換成 [日期: 匯率]
            }
            .eraseToAnyPublisher()
    }
}

//
//  AppDateStringGenerater.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/16.
//

import Foundation

class AppDateGenerater {
    static let shared = AppDateGenerater()
    private init() {}
    
    enum DateUnit: Int {
        case day = 0, week = 1, month = 2, year = 3
        
        var component: Calendar.Component {
            switch self {
                
            case .day:
                return .day
            case .week:
                return .weekOfYear
            case .month:
                return .month
            case .year:
                return .year
            }
        }
    }
    
    func generatePastSevenUnitDateInfo(from date: Date, unit: DateUnit) -> [(String, Date, Date)] {
        let dateFormatter = DateFormatter()
        var interval: DateInterval
        // set date formatter
        switch unit {
        case .day:
            dateFormatter.dateFormat = "MM/dd"
            interval = Calendar.current.dateInterval(of: .day, for: date)!
        case .week:
            dateFormatter.dateFormat = "MM/dd"
            interval = Calendar.current.dateInterval(of: .weekOfYear, for: date)!
        case .month:
            dateFormatter.dateFormat = "yyyy/MM"
            interval = Calendar.current.dateInterval(of: .month, for: date)!
        case .year:
            dateFormatter.dateFormat = "yyyy"
            interval = Calendar.current.dateInterval(of: .year, for: date)!
        }
                
        var sevenUnit: [(String, Date, Date)] = []
        for i in 0..<7 {
            let startDate = Calendar.current.date(byAdding: unit.component, value: -i, to: interval.start)!
            sevenUnit.append((dateFormatter.string(from: startDate), startDate, Calendar.current.date(byAdding: unit.component, value: -i, to: interval.end)!))
            
        }
        print(sevenUnit)
        return sevenUnit.reversed()
    }
    
    
}

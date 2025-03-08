//
//  AnalysisViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/6.
//

import Foundation
import Combine

class AnalysisViewViewModel {
    @Published var yearSelectionList: [Int] = Array(2020...Calendar.current.component(.year, from: Date()))
    
    @Published var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    var bindings: Set<AnyCancellable> = []
    
    init() {
        setBindings()
        fetchTransactions()
    }
    
    private func setBindings() {
        $selectedYear
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchTransactions()
            }
            .store(in: &bindings)
        
        $selectedMonth
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchTransactions()
            }
            .store(in: &bindings)
    }
    
    private func fetchTransactions() {
        print("fetch Transacitons \(selectedYear) \(selectedMonth)")
    }
}

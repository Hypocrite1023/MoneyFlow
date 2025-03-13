//
//  FilterPanelViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/25.
//

import Foundation
import Combine

class FilterPanelViewModel {
    @Published var dateRangeSelected: Int = 0
    @Published var transactionTypeSelected: [UUID] = CoreDataInitializer.shared.transactionTypeUUID
    @Published var categorySelected: [UUID] = []
    @Published var paymentMethodSelected: [UUID] = []
    @Published var tagSelected: [UUID] = []
    
    let dateRangeOptions: [(UUID, Int, String)] = [(UUID(), 0, "HomeView_SegementControl_Today"), (UUID(), 1, "HomeView_SegementControl_ThisWeek"), (UUID(), 2, "HomeView_SegementControl_ThisMonth"), (UUID(), 3, "HomeView_SegementControl_ThisYear")] // "今天", "這週", "這個月", "今年"
    
    func generateFilterPredicate() -> (transactionPredicate: NSPredicate?, typePredicate: NSPredicate?, categoryPredicate: NSPredicate?, paymentMethodPredicate: NSPredicate?, tagPredicate: NSPredicate?) {
        
        let datePredicate: NSPredicate = CoreDataPredicate.TransactionDateRange(rawValue: dateRangeSelected)!.predicate
        let typePredicate: NSPredicate? = transactionTypeSelected.count == 0 ? nil : NSCompoundPredicate(orPredicateWithSubpredicates: transactionTypeSelected.map {
            CoreDataPredicate.CoreDataPredicateTransactionType.type(uuid: $0).predicate
        })
        let categoryPredicate: NSPredicate? = categorySelected.isEmpty ? nil : NSCompoundPredicate(orPredicateWithSubpredicates: categorySelected.map {
            CoreDataPredicate.TransactionCategory.category(categoryUUID: $0).predicate
        })
        let paymentMethodPredicate: NSPredicate? = paymentMethodSelected.isEmpty ? nil : NSCompoundPredicate(orPredicateWithSubpredicates: paymentMethodSelected.map {
            CoreDataPredicate.TransactionPaymentMethod.paymentMethod(paymentMethodUUID: $0).predicate
        })
        let tagPredicate: NSPredicate? =  tagSelected.count == 0 ? nil : NSCompoundPredicate(orPredicateWithSubpredicates: tagSelected.map {
            CoreDataPredicate.TransactionTag.tag(tagUUID: $0).predicate
        })
        
//        let transaction = NSCompoundPredicate(andPredicateWithSubpredicates: (([datePredicate, typePredicate] as [NSPredicate?]).compactMap { $0 }))
        return (datePredicate, typePredicate, categoryPredicate, paymentMethodPredicate, tagPredicate)
        
    }
}

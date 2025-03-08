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
    @Published var transactionTypeSelected: [String] = ["收入", "支出"]
    @Published var categorySelected: [String] = []
    @Published var paymentMethodSelected: [String] = []
    @Published var tagSelected: [String] = []
    
    func generateFilterPredicate() -> (transactionPredicate: NSPredicate?, categoryPredicate: NSPredicate?, paymentMethodPredicate: NSPredicate?, tagPredicate: NSPredicate?) {
        
        let datePredicate: NSPredicate = CoreDataPredicate.TransactionDateRange(rawValue: dateRangeSelected)!.predicate
        let typePredicate: NSPredicate? = transactionTypeSelected.count == 0 ? nil : NSCompoundPredicate(orPredicateWithSubpredicates: transactionTypeSelected.map {
            CoreDataPredicate.TransactionType(rawValue: $0)!.predicate
        })
        let categoryPredicate: NSPredicate? = categorySelected.isEmpty ? nil : NSCompoundPredicate(orPredicateWithSubpredicates: categorySelected.map {
            CoreDataPredicate.TransactionCategory.category(categoryName: $0).predicate
        })
        let paymentMethodPredicate: NSPredicate? = paymentMethodSelected.isEmpty ? nil : NSCompoundPredicate(orPredicateWithSubpredicates: paymentMethodSelected.map {
            CoreDataPredicate.TransactionPaymentMethod.paymentMethod(paymentMethodName: $0).predicate
        })
        let tagPredicate: NSPredicate? =  tagSelected.count == 0 ? nil : NSCompoundPredicate(orPredicateWithSubpredicates: tagSelected.map {
            CoreDataPredicate.TransactionTag.tag(tagName: $0).predicate
        })
        
        let transaction = NSCompoundPredicate(andPredicateWithSubpredicates: (([datePredicate, typePredicate] as [NSPredicate?]).compactMap { $0 }))
        return (transaction, categoryPredicate, paymentMethodPredicate, tagPredicate)
        
    }
}

//
//  AccountingTagLoader.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/7.
//

import Foundation

class AccountingTagManager {
    static let shared = AccountingTagManager()
    static let addTagNotificationName = Notification.Name("addTagNotification")
    
    private init() {}
    
    func addTag(_ tag: String) {
        var tags = getTags() ?? []
        tags.insert(tag)
        print("tag insert successfully: \(tag)")
        // 儲存為 Array<String>
        UserDefaults.standard.set(Array(tags), forKey: AppConfig.accountingTagsUserDefaultsKey)
        NotificationCenter.default.post(name: Self.addTagNotificationName, object: nil)
    }
    
    func getTags() -> Set<String>? {
        // 從 Array<String> 轉換為 Set<String>
        if let tagsArray = UserDefaults.standard.object(forKey: AppConfig.accountingTagsUserDefaultsKey) as? [String] {
            return Set(tagsArray)
        }
        return nil
    }
}

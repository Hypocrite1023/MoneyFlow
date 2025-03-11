//
//  SettingViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/10.
//

import Foundation

class SettingViewModel {
    @Published var settings: [SettingItem] = []
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "English"
    
    init() {
        if UserDefaults.standard.string(forKey: "AppLanguage") == nil {
            UserDefaults.standard.set(AppLanguage.english.rawValue, forKey: "AppLanguage")
            selectedLanguage = AppLanguage.english.rawValue
            print("set english")
        }
        self.settings = [
            SettingItem(title: NSLocalizedString("SideMenu_SettingView_SetLanguage_Title", comment: ""), type: .selection(type: .language), value: AppLanguage(rawValue: selectedLanguage)!.localizedString),
            SettingItem(title: NSLocalizedString("SideMenu_SettingView_PasswordAndBiometricVerification_Title", comment: ""), type: .toggle, value: false)
        ]
    }
    
    func getSelectedLanguage() {
        selectedLanguage =  UserDefaults.standard.string(forKey: "AppLanguage") ?? "English"
        
        // 找到 language 設定的 index
        if let index = settings.firstIndex(where: {
            if case .selection(type: .language) = $0.type { return true }
            return false
        }) {
            // 更新對應的 SettingItem 的 value
            settings[index].value = AppLanguage(rawValue: selectedLanguage)?.localizedString ?? "English"
            settings = settings
        }
        print(selectedLanguage)
    }
    
    func updateSetting(at index: Int, with value: Any) {
        settings[index].value = value
    }
}

enum SettingType: Equatable {
    case toggle
    case text
    case selection(type: SelectionType)
    
    static func == (lhs: SettingType, rhs: SettingType) -> Bool {
        switch (lhs, rhs) {
        case (.toggle, .toggle), (.text, .text):
            return true
        case (.selection(let lhsType), .selection(let rhsType)):
            return lhsType == rhsType
        default:
            return false
        }
    }
}

enum SelectionType: Equatable {
    case language
}

class SettingItem {
    var title: String
    var type: SettingType
    var value: Any // 用來存儲具體的設置值
    
    init(title: String, type: SettingType, value: Any) {
        self.title = title
        self.type = type
        self.value = value
    }
}



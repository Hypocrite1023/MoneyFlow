//
//  LanguageSelectionViewModel.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/10.
//

import Foundation

class LanguageSelectionViewModel {
    @Published var languageList: [AppLanguage]
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "English"
    
    init() {
        self.languageList = AppLanguage.allCases
    }
    
    func setLanguage(_ language: AppLanguage) {
        selectedLanguage = language.rawValue
        UserDefaults.standard.set(language.rawValue, forKey: "AppLanguage")
    }
}

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case chinese = "Chinese, Traditional"
    
    var localizedString: String {
        switch self {
            
        case .english:
            NSLocalizedString("SideMenu_SettingView_SetLanguage_English_Title", comment: "")
        case .chinese:
            NSLocalizedString("SideMenu_SettingView_SetLanguage_TraditionalChinese_Title", comment: "")
        }
    }
}

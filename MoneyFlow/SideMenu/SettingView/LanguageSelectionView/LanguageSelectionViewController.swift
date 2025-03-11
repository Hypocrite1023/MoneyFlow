//
//  LanguageSelectionViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/10.
//

import UIKit

class LanguageSelectionViewController: UIViewController {
    
    private let contentView: LanguageSelectionView
    private let viewModel: LanguageSelectionViewModel
    
    init(viewModel: LanguageSelectionViewModel = LanguageSelectionViewModel()) {
        self.contentView = LanguageSelectionView()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationItem.title = NSLocalizedString("SideMenu_SettingView_SetLanguage_Title", comment: "")
        contentView.settingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "LanguageSelectionTableViewCell")
        contentView.settingTableView.dataSource = self
        contentView.settingTableView.delegate = self
        contentView.settingTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.updateSettingTableViewHeight()
    }
}

extension LanguageSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageSelectionTableViewCell", for: indexPath)
        var cellConfiguration = cell.defaultContentConfiguration()
        cellConfiguration.text = viewModel.languageList[indexPath.row].localizedString
        cell.contentConfiguration = cellConfiguration
        
        if AppLanguage(rawValue: viewModel.selectedLanguage) == viewModel.languageList[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension LanguageSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setLanguage(viewModel.languageList[indexPath.row])
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

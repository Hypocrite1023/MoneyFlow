//
//  SettingViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/10.
//

import UIKit
import Combine

class SettingViewController: UIViewController {
    
    private let contentView: SettingView
    private let viewModel: SettingViewModel
    private var bindings: Set<AnyCancellable> = []
    
    init(viewModel: SettingViewModel = SettingViewModel()) {
        self.contentView = SettingView()
        self.viewModel = viewModel
        print(viewModel.settings)
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
        contentView.settingTableView.dataSource = self
        contentView.settingTableView.delegate = self
        contentView.settingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
//        contentView.settingTableView.reloadData()
        setBindings()
    }
    
    override func viewDidLayoutSubviews() {
        contentView.updateSettingTableViewHeightConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getSelectedLanguage()
    }
    
    func setBindings() {
        func bindViewModelToView() {
            viewModel.$settings
                .sink { [weak self] _ in
                    self?.contentView.settingTableView.reloadData()
                    print(self?.viewModel.settings.count, "count")
                }
                .store(in: &bindings)
        }
        bindViewModelToView()
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = viewModel.settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)

        cell.textLabel?.text = setting.title
        
        switch setting.type {
        case .toggle:
            let toggle = UISwitch()
            toggle.isOn = setting.value as? Bool ?? false
            toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
            cell.accessoryView = toggle
        case .text:
            let textField = UITextField()
            textField.text = setting.value as? String
            textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
            cell.accessoryView = textField
        case .selection:
            let label = UILabel()
            label.text = setting.value as? String
            label.textColor = .secondaryLabel
            label.sizeToFit()
            
            let chevronForwardImage: UIImageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
            chevronForwardImage.tintColor = .gray
            chevronForwardImage.setContentHuggingPriority(.required, for: .horizontal) // 讓圖示不被壓縮
            
            let hstack = UIStackView(arrangedSubviews: [label, chevronForwardImage])
            hstack.axis = .horizontal
            hstack.spacing = 8
            hstack.alignment = .center
            
            let stackWidth = label.frame.width + chevronForwardImage.frame.width + 8
            let stackHeight = max(label.frame.height, chevronForwardImage.frame.height)
            hstack.frame = CGRect(x: 0, y: 0, width: stackWidth, height: stackHeight)

            cell.accessoryView = hstack
        }
        
        return cell
    }
    
    @objc func toggleChanged(_ sender: UISwitch) {
        if let indexPath = contentView.settingTableView.indexPathForSelectedRow {
            viewModel.updateSetting(at: indexPath.row, with: sender.isOn)
        }
    }

    @objc func textChanged(_ sender: UITextField) {
        if let indexPath = contentView.settingTableView.indexPathForSelectedRow {
            viewModel.updateSetting(at: indexPath.row, with: sender.text ?? "")
        }
    }
    
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.settings[indexPath.row].type == .selection(type: .language) {
            navigationItem.backButtonTitle = NSLocalizedString("SideMenu_AppSetting_Title", comment: "")
            navigationController?.pushViewController(LanguageSelectionViewController(), animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

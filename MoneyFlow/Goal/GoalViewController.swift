//
//  GoalViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/17.
//

import UIKit
import Combine

class GoalViewController: UIViewController {
    
    private var contentView: GoalView = GoalView()
    private let viewModel: GoalViewViewModel
    private var bindings: Set<AnyCancellable> = []
    private var dataSource: UITableViewDiffableDataSource<String, GoalItem>!
    
    init(viewModel: GoalViewViewModel = GoalViewViewModel()) {
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
        contentView.addGoalButton.addTarget(self, action: #selector(addGoal), for: .touchUpInside)
//        print(CoreDataManager.shared.fetchAllGoalsStatus())
        
        
        contentView.savingGoalPreviewTableView.register(GoalPreviewView.self, forCellReuseIdentifier: "GoalPreviewView")
        contentView.savingGoalPreviewTableView.delegate = self
        configDataSource()
        
        setBindings()
        
//        contentView.goalPreviewTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "GoalViewHeaderView")
        
        contentView.dailyExpenseGoal.setGoalName(goalName: "每日花費")
        contentView.weeklyExpenseGoal.setGoalName(goalName: "每週花費")
        contentView.monthlyExpenseGoal.setGoalName(goalName: "每月花費")
        
        let dailyExpenseGoalTap = UITapGestureRecognizer(target: self, action: #selector(navigateToDailyExpense))
        contentView.dailyExpenseGoal.addGestureRecognizer(dailyExpenseGoalTap)
        
        let weeklyExpenseGoalTap = UITapGestureRecognizer(target: self, action: #selector(navigateToWeeklyExpense))
        contentView.weeklyExpenseGoal.addGestureRecognizer(weeklyExpenseGoalTap)
        
        let monthlyExpenseGoalTap = UITapGestureRecognizer(target: self, action: #selector(navigateToMonthlyExpense))
        contentView.monthlyExpenseGoal.addGestureRecognizer(monthlyExpenseGoalTap)
        
        
        contentView.expenseGoalSettingButton.addTarget(self, action: #selector(settingExpenseGoalLimit), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadGoal()
        viewModel.loadDailyWeeklyMonthlyGoal()
        viewModel.loadCurrentExpense()
        applySnapshot()
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func addGoal() {
        let vc = AddOrEditGoalViewController(viewModel: AddOrEditGoalViewViewModel(mode: .add))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func configDataSource() {
        dataSource = UITableViewDiffableDataSource<String, GoalItem>(tableView: contentView.savingGoalPreviewTableView) { tableView, indexPath, item in
            let cell = self.contentView.savingGoalPreviewTableView.dequeueReusableCell(withIdentifier: "GoalPreviewView", for: indexPath) as? GoalPreviewView
            cell?.setGoalName(goalName: item.name!)
            cell?.setGoalAmount(goalAmount: item.targetAmount)
            cell?.setNowAmount(nowAmount: item.currentAmount)
            cell?.setGoalProgressView(progress: item.currentAmount / item.targetAmount)
            return cell
        }
    }
    
    func applySnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<String, GoalItem>()
        
        let groupedTransaction = Dictionary(grouping: viewModel.goalList) { goal in
            if let endDate = goal.endDate {
                return endDate > .now ? "進行中" : "已結束"
            } else {
                return "進行中"
            }
        }
        snapShot.appendSections(groupedTransaction.keys.sorted().reversed())
        
        for group in groupedTransaction.keys.sorted() {
            if let items = groupedTransaction[group] {
                snapShot.appendItems(items, toSection: group)
            }
        }
        
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    func setBindings() {
        func bindViewModelToView() {
            viewModel.$goalList
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] goalList in
                    self?.contentView.savingGoalPreviewTableView.backgroundView?.isHidden = goalList.isEmpty ? false : true
//                    self?.applySnapshot()
                })
                .store(in: &bindings)
            viewModel.$dailyGoal
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] value in
                    self?.contentView.dailyExpenseGoal.setGoalAmount(goalAmount: value)
                })
                .store(in: &bindings)
            viewModel.$weeklyGoal
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] value in
                    self?.contentView.weeklyExpenseGoal.setGoalAmount(goalAmount: value)
                })
                .store(in: &bindings)
            viewModel.$monthlyGoal
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] value in
                    self?.contentView.monthlyExpenseGoal.setGoalAmount(goalAmount: value)
                })
                .store(in: &bindings)
            viewModel.$currentDailyExpense
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] currentDailyExpense in
                    self?.contentView.dailyExpenseGoal.nowAmountLabel.text = AppFormatter.shared.currencyNumberFormatter.string(from: currentDailyExpense as NSNumber)
                    guard let dailyGoal = self?.viewModel.dailyGoal else { return }
                    self?.contentView.dailyExpenseGoal.setGoalProgressView(progress: currentDailyExpense / dailyGoal)
                })
                .store(in: &bindings)
            viewModel.$currentWeeklyExpense
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] currentWeeklyExpense in
                    self?.contentView.weeklyExpenseGoal.nowAmountLabel.text = AppFormatter.shared.currencyNumberFormatter.string(from: currentWeeklyExpense as NSNumber)
                    guard let weeklyGoal = self?.viewModel.dailyGoal else { return }
                    self?.contentView.weeklyExpenseGoal.setGoalProgressView(progress: currentWeeklyExpense / weeklyGoal)
                })
                .store(in: &bindings)
            viewModel.$currentMonthlyExpense
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] currentMonthlyExpense in
                    self?.contentView.monthlyExpenseGoal.nowAmountLabel.text = AppFormatter.shared.currencyNumberFormatter.string(from: currentMonthlyExpense as NSNumber)
                    guard let monthlyGoal = self?.viewModel.dailyGoal else { return }
                    self?.contentView.monthlyExpenseGoal.setGoalProgressView(progress: currentMonthlyExpense / monthlyGoal)
                })
                .store(in: &bindings)
        }
        bindViewModelToView()
    }
    
    @objc func settingExpenseGoalLimit() {
        let vc = SettingExpenseGoalViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func navigateToDailyExpense() {
        tabBarController?.selectedIndex = 1
        let navigationViewController = tabBarController?.selectedViewController as? UINavigationController
        let transactionViewController = navigationViewController?.topViewController as? TransactionViewController
        transactionViewController?.viewModel.filterPanelViewModel.dateRangeSelected = 0
        transactionViewController?.viewModel.filterPanelViewModel.transactionTypeSelected = [1]
    }
    @objc func navigateToWeeklyExpense() {
        tabBarController?.selectedIndex = 1
        let navigationViewController = tabBarController?.selectedViewController as? UINavigationController
        let transactionViewController = navigationViewController?.topViewController as? TransactionViewController
        transactionViewController?.viewModel.filterPanelViewModel.dateRangeSelected = 1
        transactionViewController?.viewModel.filterPanelViewModel.transactionTypeSelected = [1]
    }
    @objc func navigateToMonthlyExpense() {
        tabBarController?.selectedIndex = 1
        let navigationViewController = tabBarController?.selectedViewController as? UINavigationController
        let transactionViewController = navigationViewController?.topViewController as? TransactionViewController
        transactionViewController?.viewModel.filterPanelViewModel.dateRangeSelected = 2
        transactionViewController?.viewModel.filterPanelViewModel.transactionTypeSelected = [1]
    }
}

extension GoalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = dataSource.itemIdentifier(for: indexPath)
        guard let goal else { return }
        let goalDetailViewController = GoalDetailViewViewController(goal: goal)
        
        navigationController?.pushViewController(goalDetailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "修改") { action, view, closure in
            print("edit")
            guard let goal = self.dataSource.itemIdentifier(for: indexPath) else { return }
            let vc = AddOrEditGoalViewController(viewModel: AddOrEditGoalViewViewModel(mode: .edit, goal: goal))
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        editAction.backgroundColor = .systemOrange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { action, view, closure in
            print("delete")
        }
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let snapShot = dataSource.snapshot()
        
        let headerView = UITableViewHeaderFooterView(reuseIdentifier: "GoalViewHeaderView")
        let sectionIdentifier = snapShot.sectionIdentifiers[section]
        let titleLabel = UILabel()
        titleLabel.text = sectionIdentifier
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        headerView.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: headerView.contentView.leadingAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: headerView.contentView.widthAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: headerView.contentView.topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: headerView.contentView.bottomAnchor, constant: -10).isActive = true
        
        
        return headerView
    }
    
    
}

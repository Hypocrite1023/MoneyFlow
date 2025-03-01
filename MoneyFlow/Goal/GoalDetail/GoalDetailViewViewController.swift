//
//  GoalDetailViewViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/27.
//

import UIKit

class GoalDetailViewViewController: UIViewController {
    
    private let viewModel: GoalDetailViewViewModel
    private let contentView = GoalDetailView()
    private var dataSource: UITableViewDiffableDataSource<GoalDetailViewViewModel.DateSection, Transaction>!
    
    init(goal: GoalItem) {
        self.viewModel = GoalDetailViewViewModel(goal: goal)
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
        navigationItem.title = viewModel.goal.name
        contentView.relationTransacitonTableView.register(TransactionItemView.self, forCellReuseIdentifier: "GoalDetailViewTransactionItemView")
        contentView.relationTransacitonTableView.delegate = self
        configDataSource()
        applySnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        let value = viewModel.goal.currentAmount / viewModel.goal.targetAmount
        contentView.progressView.animateProgress(duration: TimeInterval(0.3), toValue: value)
        contentView.progressView.valueLabel.text = value.formatted(.percent)
        contentView.setGoalDuration(startDate: viewModel.startDate, endDate: viewModel.endDate)
//        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configDataSource() {
        dataSource = UITableViewDiffableDataSource<GoalDetailViewViewModel.DateSection, Transaction>(tableView: contentView.relationTransacitonTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoalDetailViewTransactionItemView", for: indexPath) as? TransactionItemView
            guard let cell else { return UITableViewCell() }
            cell.setUpCell(with: itemIdentifier)
            return cell
        })
    }
    
    func applySnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<GoalDetailViewViewModel.DateSection, Transaction>()
        
        let groupedTransaction = Dictionary(grouping: viewModel.relationTransaction) { transaction in
            AppFormatter.shared.dateFormatter.string(from: transaction.date)
        }
        
        let transactionDates = groupedTransaction.keys.sorted { $0 < $1 }
        for date in transactionDates {
            snapShot.appendSections([.date(date)])
            if let transaction = groupedTransaction[date] {
                snapShot.appendItems(transaction, toSection: .date(date))
            }
        }
        dataSource.apply(snapShot, animatingDifferences: true)
    }

}

extension GoalDetailViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "編輯") { action, view, closure in
            print(action)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let transaction = dataSource.itemIdentifier(for: indexPath) {
            let transactionDetailViewController = TransactionDetailViewViewController(transaction: transaction, viewModel: TransactionDetailViewViewModel(transaction: transaction))

            navigationController?.pushViewController(transactionDetailViewController, animated: true)
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


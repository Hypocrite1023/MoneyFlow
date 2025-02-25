//
//  TransactionDetailViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/14.
//

import UIKit

class TransactionViewController: UIViewController {
    private var contentView: TransactionView
    private let viewModel: TransactionViewViewModel
    private var tableViewDataSource: UITableViewDiffableDataSource<TransactionViewViewModel.TransactionSection, Transaction>!
    
    init(viewModel: TransactionViewViewModel = TransactionViewViewModel()) {
        self.contentView = TransactionView()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.transactionFilterButton.addTarget(self, action: #selector(showFilterPanel), for: .touchUpInside)
        
        contentView.transactionTableView.register(TransactionItemView.self, forCellReuseIdentifier: "TransactionItemView")
        contentView.transactionTableView.delegate = self
        tableViewDataSource = UITableViewDiffableDataSource(tableView: contentView.transactionTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionItemView", for: indexPath) as? TransactionItemView else {
                return UITableViewCell()
            }
            cell.setUpCell(with: itemIdentifier)
            return cell
        })
        
        if let transaction = CoreDataManager.shared.fetchTransaction(withPredicate: AppConfig.TransactionTimePredicate.week.bothPredicate!) {
            applySnapShot(transactions: transaction)
        }
        
    }
    
    func applySnapShot(transactions: [Transaction]) {
        var snapShot = NSDiffableDataSourceSnapshot<TransactionViewViewModel.TransactionSection, Transaction>()
        
        let groupedTransaction = Dictionary(grouping: transactions) { transaction in
            AppFormatter.shared.dateFormatter.string(from: transaction.date)
        }
        
        let sortedDates = groupedTransaction.keys.sorted { $0 < $1 }
        
        for date in sortedDates {
            let section = TransactionViewViewModel.TransactionSection.date(date)
            snapShot.appendSections([section])
            if let transaction = groupedTransaction[date] {
                snapShot.appendItems(transaction, toSection: section)
            }
        }
        
        tableViewDataSource.apply(snapShot, animatingDifferences: true)
    }
    
    @objc func showFilterPanel() {
        let filterPanelVC = FilterPanelViewController()
        filterPanelVC.filterDataDelegate = self
        filterPanelVC.view.backgroundColor = .systemBackground
        filterPanelVC.modalPresentationStyle = .pageSheet

        if let sheet = filterPanelVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
        }

        present(filterPanelVC, animated: true)
    }
}

extension TransactionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let snapShot = tableViewDataSource.snapshot()
        
        let headerView = UITableViewHeaderFooterView(reuseIdentifier: "HeaderView")
        let sectionIdentifier = snapShot.sectionIdentifiers[section]
        switch sectionIdentifier {
        case .date(let dateString):
            headerView.textLabel?.text = dateString
            headerView.textLabel?.textColor = .black
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableViewDataSource.itemIdentifier(for: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TransactionViewController: TransactionFilterDataDelegate {
    func reloadTransaction(with transaction: [Transaction]) {
        print(transaction)
        applySnapShot(transactions: transaction)
    }
    
    
}

//
//  TransactionDetailViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/14.
//

import UIKit

class TransactionViewController: UIViewController {
    private var contentView: TransactionView
    var viewModel: TransactionViewViewModel
    private var tableViewDataSource: UITableViewDiffableDataSource<TransactionViewViewModel.TransactionSection, Transaction>!
    
    init(viewModel: TransactionViewViewModel = TransactionViewViewModel()) {
        self.contentView = TransactionView()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("TransactionViewController deinit")
    }
    
    override func loadView() {
        view = contentView
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = true
//        let transaction = CoreDataManager.shared.fetchTransaction(withPredicate: viewModel.filterPanelViewModel.generateFilterPredicate())
        viewModel.fetchTransactions()
        applySnapShot()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.transactionFilterButton.addTarget(self, action: #selector(showFilterPanel), for: .touchUpInside)
        
        contentView.transactionTableView.register(TransactionItemView.self, forCellReuseIdentifier: "TransactionItemView")
        contentView.transactionTableView.delegate = self
        
        configDataSource()
    }
    
    func applySnapShot() {
        if viewModel.transactions.isEmpty {
            contentView.transactionTableView.backgroundView?.isHidden = false
        } else {
            contentView.transactionTableView.backgroundView?.isHidden = true
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<TransactionViewViewModel.TransactionSection, Transaction>()
        
        let groupedTransaction = Dictionary(grouping: viewModel.transactions) { transaction in
            AppFormatter.shared.dateFormatter.string(from: transaction.date)
        }
        
        let sortedDates = groupedTransaction.keys.sorted { $0 < $1 }
        
        for date in sortedDates {
            let section = TransactionViewViewModel.TransactionSection.date(date)
            snapShot.appendSections([section])
            if let transactions = groupedTransaction[date] {
                snapShot.appendItems(transactions, toSection: section)
            }
        }
        
        tableViewDataSource.apply(snapShot, animatingDifferences: true)
    }
    
    @objc func showFilterPanel() {
        let filterPanelVC = FilterPanelViewController(viewModel: viewModel.filterPanelViewModel)
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

extension TransactionViewController {
    func configDataSource() {
        tableViewDataSource = UITableViewDiffableDataSource(tableView: contentView.transactionTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionItemView", for: indexPath) as? TransactionItemView else {
                return UITableViewCell()
            }
            cell.setUpCell(with: itemIdentifier)
            return cell
        })
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
        if let transaction = tableViewDataSource.itemIdentifier(for: indexPath) {
            let transactionDetailViewController = TransactionDetailViewViewController(transaction: transaction, viewModel: TransactionDetailViewViewModel(transaction: transaction))
            transactionDetailViewController.modalPresentationStyle = .fullScreen

            navigationController?.pushViewController(transactionDetailViewController, animated: true)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TransactionViewController: TransactionFilterDataDelegate {
    func reloadTransaction() {
//        print(transaction)
        viewModel.fetchTransactions()
        applySnapShot()
    }
    
    
}

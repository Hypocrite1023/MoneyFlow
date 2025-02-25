//
//  FilterPanelViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/15.
//

import UIKit
import Combine

class FilterPanelViewController: UIViewController {
    
    private var contentView: FilterPanelView
    private var viewModel: FilterPanelViewModel
    private var bindings: Set<AnyCancellable> = []
    weak var filterDataDelegate: TransactionFilterDataDelegate?
    
    init(viewModel: FilterPanelViewModel = FilterPanelViewModel()) {
        self.contentView = FilterPanelView()
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
//        NotificationCenter.default.addObserver(self, selector: #selector(fetchTransactionByDate), name: SingleSelectionView.singleSelectionButtonStateChangeNotification, object: (view as? FilterPanelView)?.dateRangeSelector)
        
        setupBindings()
    }
    
    deinit {
//        NotificationCenter.default.removeObserver(self, name: SingleSelectionView.singleSelectionButtonStateChangeNotification, object: (view as? FilterPanelView)?.dateRangeSelector)
    }
    
    private func setupBindings() {
        func bindViewModelToView() {
            contentView.dateRangeSelector.$selectedIndex
                .dropFirst()
                .map {
                    $0!
                }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
                    self.viewModel.dateRangeSelected = value
                    self.filterDataDelegate?.reloadTransaction(with: CoreDataManager.shared.fetchTransaction(withPredicate: self.viewModel.generateFilterPredicate()))
                    
                }
                .store(in: &bindings)
            contentView.typeSelector.$selectedIndex
                .dropFirst()
                .map{ Array($0) }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
                    self.viewModel.transactionTypeSelected = value
                    self.filterDataDelegate?.reloadTransaction(with: CoreDataManager.shared.fetchTransaction(withPredicate: self.viewModel.generateFilterPredicate()))
                }
                .store(in: &bindings)
            contentView.categorySelector.$selectedIndex
                .dropFirst()
                .map{ Array($0) }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
                    self.viewModel.categorySelected =
                    value.compactMap({ index in
                        self.contentView.categorySelector.buttonList[index].title(for: .normal)
                    })
                    self.filterDataDelegate?.reloadTransaction(with: CoreDataManager.shared.fetchTransaction(withPredicate: self.viewModel.generateFilterPredicate()))
                }
                .store(in: &bindings)
            contentView.paymentMethodSelector.$selectedIndex
                .dropFirst()
                .map{ Array($0) }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
                    self.viewModel.paymentMethodSelected =
                    value.compactMap({ index in
                        return self.contentView.paymentMethodSelector.buttonList[index].title(for: .normal)
                    })
                    self.filterDataDelegate?.reloadTransaction(with: CoreDataManager.shared.fetchTransaction(withPredicate: self.viewModel.generateFilterPredicate()))
                }
                .store(in: &bindings)
            contentView.tagSelector.$selectedIndex
                .dropFirst()
                .map{ Array($0) }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
                    self.viewModel.tagSelected =
                    value.compactMap({ index in
                        return self.contentView.tagSelector.buttonList[index].title(for: .normal)
                    })
                    self.filterDataDelegate?.reloadTransaction(with: CoreDataManager.shared.fetchTransaction(withPredicate: self.viewModel.generateFilterPredicate()))
                }
                .store(in: &bindings)
            
            
        }
        bindViewModelToView()
    }
}

protocol TransactionFilterDataDelegate: AnyObject {
    func reloadTransaction(with transaction: [Transaction])
}

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
    
    init(viewModel: FilterPanelViewModel) {
        self.contentView = FilterPanelView(dateRangeSelectorSelectionList: viewModel.dateRangeOptions.map{($0.0, $0.2)}, frame: .zero)
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
        func bindViewToViewModel() {
            contentView.dateRangeSelector.$selectedIndex
                .dropFirst()
                .removeDuplicates()
//                .map {
//                    $0!
//                }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let value else {
                        return
                    }
//                    print(value, "bindViewToViewModel")
                    self?.viewModel.dateRangeSelected = (self?.viewModel.dateRangeOptions.firstIndex(where: { (uuid, index, str) in
                        value == uuid
                    }))!
                    self?.filterDataDelegate?.reloadTransaction()
                    
                }
                .store(in: &bindings)
            contentView.typeSelector.$selectedIndex
                .dropFirst()
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
                    self.viewModel.transactionTypeSelected = Array(value)
                    self.filterDataDelegate?.reloadTransaction()
                    if self.viewModel.transactionTypeSelected.count == 2 {
                        self.contentView.categorySelector.updateSelectionList(list: [])
                    } else if self.viewModel.transactionTypeSelected.count == 1 {
                        self.contentView.categorySelector.updateSelectionList(list: CoreDataManager.shared.fetchTransactionCategories(predicate: .type(categoryType: CoreDataInitializer.shared.transactionTypeUUID[0])).map { ($0.uuid, $0.name) } )
                    } else {
                        self.contentView.categorySelector.updateSelectionList(list: [])
                    }
                }
                .store(in: &bindings)
            contentView.categorySelector.$selectedIndex
                .dropFirst()
                .removeDuplicates()
                .debounce(for: 1, scheduler: DispatchQueue.main)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
//                    print(value)
                    self.viewModel.categorySelected = Array(value)
//                    print(self.viewModel.categorySelected, "----")
                    self.filterDataDelegate?.reloadTransaction()
                }
                .store(in: &bindings)
            contentView.paymentMethodSelector.$selectedIndex
                .dropFirst()
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
                    self.viewModel.paymentMethodSelected = Array(value)
                    self.filterDataDelegate?.reloadTransaction()
                }
                .store(in: &bindings)
            contentView.tagSelector.$selectedIndex
                .dropFirst()
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
                    self.viewModel.tagSelected = Array(value)
                    self.filterDataDelegate?.reloadTransaction()
                }
                .store(in: &bindings)
        }
        func bindViewModelToView() {
            viewModel.$dateRangeSelected
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
//                    print(index, "bindViewModelToView")
                    self?.contentView.dateRangeSelector.selectedIndex = self?.viewModel.dateRangeOptions[index].0
                }
                .store(in: &bindings)
            viewModel.$transactionTypeSelected
                .dropFirst()
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
                    self?.contentView.typeSelector.selectedIndex = Set(index)
                }
                .store(in: &bindings)
            viewModel.$categorySelected
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
                    self?.contentView.categorySelector.selectedIndex = Set(index)
                }
                .store(in: &bindings)
            viewModel.$paymentMethodSelected
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
                    self?.contentView.paymentMethodSelector.selectedIndex = Set(index)
                }
                .store(in: &bindings)
            viewModel.$tagSelected
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
                    self?.contentView.tagSelector.selectedIndex = Set(index)
                }
                .store(in: &bindings)
        }
        bindViewToViewModel()
        bindViewModelToView()
    }
}

protocol TransactionFilterDataDelegate: AnyObject {
    func reloadTransaction()
}

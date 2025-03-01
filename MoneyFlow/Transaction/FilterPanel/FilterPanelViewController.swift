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
        func bindViewToViewModel() {
            contentView.dateRangeSelector.$selectedIndex
                .dropFirst()
                .removeDuplicates()
                .map {
                    $0!
                }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
                    print(value, "bindViewToViewModel")
                    self.viewModel.dateRangeSelected = value
                    self.filterDataDelegate?.reloadTransaction()
                    
                }
                .store(in: &bindings)
            contentView.typeSelector.$selectedIndex
                .dropFirst()
                .removeDuplicates()
                .map{ Array($0) }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self else {
                        return
                    }
                    self.viewModel.transactionTypeSelected = value
                    self.filterDataDelegate?.reloadTransaction()
                }
                .store(in: &bindings)
            contentView.categorySelector.$selectedIndex
                .dropFirst()
                .removeDuplicates()
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
                    self.filterDataDelegate?.reloadTransaction()
                }
                .store(in: &bindings)
            contentView.paymentMethodSelector.$selectedIndex
                .dropFirst()
                .removeDuplicates()
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
                    self.filterDataDelegate?.reloadTransaction()
                }
                .store(in: &bindings)
            contentView.tagSelector.$selectedIndex
                .dropFirst()
                .removeDuplicates()
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
                    self.filterDataDelegate?.reloadTransaction()
                }
                .store(in: &bindings)
        }
        func bindViewModelToView() {
            viewModel.$dateRangeSelected
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
                    print(index, "bindViewModelToView")
                    self?.contentView.dateRangeSelector.selectedIndex = index
                }
                .store(in: &bindings)
            viewModel.$transactionTypeSelected
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
                    self?.contentView.categorySelector.selectedIndex = Set(index.map {
                        (self?.contentView.categorySelector.selectionList.firstIndex(of: $0))!
                    })
                }
                .store(in: &bindings)
            viewModel.$paymentMethodSelected
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
                    self?.contentView.paymentMethodSelector.selectedIndex = Set(index.map {
                        (self?.contentView.paymentMethodSelector.selectionList.firstIndex(of: $0))!
                    })
                }
                .store(in: &bindings)
            viewModel.$tagSelected
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
                    self?.contentView.tagSelector.selectedIndex = Set(index.map {
                        (self?.contentView.tagSelector.selectionList.firstIndex(of: $0))!
                    })
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

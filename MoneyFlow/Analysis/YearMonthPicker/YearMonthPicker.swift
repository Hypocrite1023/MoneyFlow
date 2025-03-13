//
//  YearMonthPicker.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/3/6.
//

import UIKit

class YearMonthPicker: UIView {
    
    private let yearPicker: UIButton = UIButton(configuration: .tinted())
    private let yearLabel: UILabel = UILabel()
    private let monthPicker: UIButton = UIButton(configuration: .tinted())
    private let monthLabel: UILabel = UILabel()
    private var yearList: [Int]
    private var monthList: [Int] = Array(1...12)
    @Published var selectedYear: Int
    @Published var selectedMonth: Int
    
    private var monthPickerActions: [UIAction] = []
    
    init(yearList: [Int], selectedYear: Int, selectedMonth: Int) {
        self.yearList = yearList
        self.selectedYear = selectedYear
        self.selectedMonth = selectedMonth
        super.init(frame: .zero)
        
        setView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        yearPicker.setTitle(selectedYear.description, for: .normal)
        yearPicker.tintColor = .black
        configureYearPicker()
        
        yearLabel.text = NSLocalizedString("YearMonthPicker_YearLabel_Title", comment: "年")
        
        monthPicker.setTitle(selectedMonth.description, for: .normal)
        monthPicker.tintColor = .black
        reloadMonthAction()
        monthPicker.showsMenuAsPrimaryAction = true
        
        monthLabel.text = NSLocalizedString("YearMonthPicker_MonthLabel_Title", comment: "月")
    }
    
    private func setupConstraint() {
        [yearPicker, yearLabel, monthPicker, monthLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        
        let layoutConstraints = [
            yearPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            yearPicker.topAnchor.constraint(equalTo: topAnchor),
            yearPicker.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            yearLabel.leadingAnchor.constraint(equalTo: yearPicker.trailingAnchor, constant: 2),
            yearLabel.topAnchor.constraint(equalTo: topAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            monthPicker.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor, constant: 10),
            monthPicker.topAnchor.constraint(equalTo: topAnchor),
            monthPicker.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            monthLabel.leadingAnchor.constraint(equalTo: monthPicker.trailingAnchor, constant: 2),
            monthLabel.topAnchor.constraint(equalTo: topAnchor),
            monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func configureYearPicker() {
        let yearPickerActions = yearList.map { year in
            UIAction(title: year.description, state: selectedYear == year ? .on : .off) { action in
                self.selectedYear = year
                self.yearPicker.setTitle(year.description, for: .normal)
                if year == Calendar.current.component(.year, from: .now) {
                    self.monthList = Array(1...Calendar.current.component(.month, from: .now))
                    self.reloadMonthAction()
                } else {
                    self.monthList = Array(1...12)
                    self.reloadMonthAction()
                }
            }
        }
        
        let yearPickerMenu = UIMenu(title: "年份", options: [.singleSelection], children: yearPickerActions)
        yearPicker.menu = yearPickerMenu
        yearPicker.showsMenuAsPrimaryAction = true
    }
    
    private func reloadMonthAction() {
        if selectedYear == Calendar.current.component(.year, from: .now) {
            self.monthList = Array(1...Calendar.current.component(.month, from: .now))
        } else {
            self.monthList = Array(1...12)
        }
        monthPickerActions = monthList.map { month in
            UIAction(title: month.description, state: selectedMonth == month ? .on : .off) { action in
                self.selectedMonth = month
                self.monthPicker.setTitle(month.description, for: .normal)
            }
        }
        
        let monthPickerMenu = UIMenu(title: "月份", options: [.singleSelection], children: monthPickerActions)
        monthPicker.menu = monthPickerMenu
    }
}

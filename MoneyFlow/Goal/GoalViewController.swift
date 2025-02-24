//
//  GoalViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/2/17.
//

import UIKit

class GoalViewController: UIViewController {
    
    private var goalView: GoalView?
    private var dataSource: UITableViewDiffableDataSource<Int, GoalItem>!
    
    override func loadView() {
        super.loadView()
        view = GoalView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        goalView = (view as? GoalView)
        goalView?.addGoalButton.addTarget(self, action: #selector(addGoal), for: .touchUpInside)
        print(CoreDataManager.shared.fetchAllGoalsStatus())
        
        
        goalView?.goalPreviewTableView.register(GoalPreviewView.self, forCellReuseIdentifier: "GoalPreviewView")
        dataSource = UITableViewDiffableDataSource<Int, GoalItem>(tableView: goalView!.goalPreviewTableView) { tableView, indexPath, item in
            let cell = self.goalView?.goalPreviewTableView.dequeueReusableCell(withIdentifier: "GoalPreviewView", for: indexPath) as? GoalPreviewView
            cell?.setGoalName(goalName: item.name!)
            cell?.setGoalAmount(goalAmount: item.targetAmount)
            cell?.setNowAmount(nowAmount: item.currentAmount)
            cell?.setGoalProgressView(progress: item.currentAmount / item.targetAmount)
            return cell
        }
        goalView?.goalPreviewTableView.dataSource = dataSource
//        loadGoalData()
        if goalView?.goalPreviewTableView.dataSource == nil {
            goalView?.goalPreviewTableView.backgroundView?.isHidden = false
        } else {
            goalView?.goalPreviewTableView.backgroundView?.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGoalData()
//        (view as? GoalView)?.progressView.animateProgress(duration: 0.5, toValue: 0.8)
    }
    
    @objc func addGoal() {
        let vc = AddGoalViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func loadGoalData() {
        if let goals = CoreDataManager.shared.fetchAllGoalsStatus() {
            var snapShot = NSDiffableDataSourceSnapshot<Int, GoalItem>()
            snapShot.appendSections([0])
            snapShot.appendItems(goals)
            
            dataSource.apply(snapShot, animatingDifferences: true)
        }
        
        
    }
}

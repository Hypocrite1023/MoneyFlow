//
//  ViewController.swift
//  MoneyFlow
//
//  Created by YI-CHUN CHIU on 2025/1/16.
//

import UIKit

class HomeViewController: UIViewController {
    
    var homeView: HomeView?
    
    override func loadView() {
        super.loadView()
        homeView = HomeView()
        
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        
    }


}


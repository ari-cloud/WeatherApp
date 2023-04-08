//
//  HistoryViewController.swift
//  weather
//
//  Created by Арина Моргачева on 05.04.2023.
//

import UIKit

class HistoryViewController: UIViewController {

    let viewModel = HistoryViewModel()
    
    private let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(historyTableView)
        
        setupLayoutConstraints()

    }
    
    func setupLayoutConstraints() {
        let conctraints = [
            historyTableView.topAnchor.constraint(equalTo: view.topAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]
        NSLayoutConstraint.activate(conctraints)
    }
  
}

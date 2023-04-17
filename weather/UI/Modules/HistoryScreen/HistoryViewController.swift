//
//  HistoryViewController.swift
//  weather
//
//  Created by Арина Моргачева on 05.04.2023.
//

import UIKit
import RxSwift

class HistoryViewController: UIViewController, UIScrollViewDelegate {

    var viewModel: HistoryViewModel?
    
    private let disposeBag = DisposeBag()
    
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
    
    private func bindFavouriteTableView() {
        historyTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.cellId)
        historyTableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel?.items.bind(to: historyTableView.rx.items(cellIdentifier: HistoryTableViewCell.cellId, cellType: HistoryTableViewCell.self)){index, item, cell in
            cell.cityNameLabel.text = item
        }.disposed(by: disposeBag)
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

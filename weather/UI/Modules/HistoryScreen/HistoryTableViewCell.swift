//
//  TableViewCell.swift
//  weather
//
//  Created by Арина Моргачева on 05.04.2023.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    static let cellId = String(describing: HistoryTableViewCell.self)

    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cityNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayoutConstraints() {
        let constraints = [
            cityNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cityNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

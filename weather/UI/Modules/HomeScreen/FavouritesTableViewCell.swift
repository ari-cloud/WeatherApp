//
//  FavouritesTableViewCell.swift
//  weather
//
//  Created by Арина Моргачева on 09.04.2023.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {

    private let favouriteCityLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favouriteCityTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .gray
        
        setupLayoutConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayoutConstraint() {
        contentView.addSubview(favouriteCityLabel)
        contentView.addSubview(favouriteCityTemperatureLabel)
        
        let favouriteCityConstraints = [
            favouriteCityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favouriteCityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
        ]
        
        let favouriteCityTemperatureConstraints = [
            favouriteCityTemperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favouriteCityTemperatureLabel.topAnchor.constraint(equalTo: favouriteCityLabel.bottomAnchor, constant: 10),
            favouriteCityTemperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(favouriteCityConstraints + favouriteCityTemperatureConstraints)
    }
    
}

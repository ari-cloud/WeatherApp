//
//  ViewController.swift
//  weather
//
//  Created by Арина Моргачева on 16.03.2023.
//

import UIKit
import RxSwift

class HomeScreenViewController: UIViewController {
    
    let viewModel = HomeScreenViewModel()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "What's the weather in"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.textAlignment = .center
        textField.placeholder = "Tap your city"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2.0
        let color = UIColor.gray
        textField.layer.borderColor = color.cgColor
        return textField
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Select the city"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favouriteIconNotChoosen"), for: .normal)
        button.addTarget(self, action: #selector(favouriteButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tempertureLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0°"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favouritesView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstFavouriteCityLabel: UILabel = {
        let label = UILabel()
        label.text = "First"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstFavouriteCityTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondFavouriteCityLabel: UILabel = {
        let label = UILabel()
        label.text = "Second"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondFavouriteCityTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let thirdFavouriteCityLabel: UILabel = {
        let label = UILabel()
        label.text = "Third"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let thirdFavouriteCityTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let showHistoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("Show History", for: button.state)
        button.addTarget(self, action: #selector(showHistoryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        view.addGestureRecognizer(tap)
        view.backgroundColor = .white
        
        setupLayoutConstraints()
        
        viewModel.weatherViewModel.subscribe(onNext: { [weak self] weather in
            guard let self else { return }
            DispatchQueue.main.async {
                self.cityNameLabel.text = weather.name
                self.tempertureLabel.text = weather.degrees
            }
        })
        .disposed(by: disposeBag)
        
        textField.rx.text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
    }
    
    @objc func showHistoryButtonAction(sender: UIButton) {
        navigationController?.pushViewController(HistoryViewController(), animated: true)
    }
    
    @objc func favouriteButtonAction(sender: UIButton) {
        if sender.image(for: .normal) == UIImage(named: "favouriteIconNotChoosen") {
            guard let name = self.cityNameLabel.text else { return }
            guard let temperature = self.tempertureLabel.text else { return }
            print(name)
            viewModel.addToFavouriteItems(name: name, temperature: temperature)
            sender.setImage(UIImage(named: "favouriteIconChoosen"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "favouriteIconNotChoosen"), for: .normal)
        }
        
    }
    
    private func setupLayoutConstraints() {
        view.addSubview(weatherLabel)
        view.addSubview(textField)
        view.addSubview(cityNameLabel)
        view.addSubview(favouriteButton)
        view.addSubview(tempertureLabel)
        view.addSubview(showHistoryButton)
        view.addSubview(favouritesView)
        favouritesView.addSubview(firstFavouriteCityLabel)
        favouritesView.addSubview(firstFavouriteCityTemperatureLabel)
        favouritesView.addSubview(secondFavouriteCityLabel)
        favouritesView.addSubview(secondFavouriteCityTemperatureLabel)
        favouritesView.addSubview(thirdFavouriteCityLabel)
        favouritesView.addSubview(thirdFavouriteCityTemperatureLabel)
        
        let weatherLabelConstraints = [
            weatherLabel.heightAnchor.constraint(equalToConstant: 24),
            weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ]
            
        let textFieldConstraints = [
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 10)
        ]
        
        let cityNameLabelConstraints = [
            cityNameLabel.heightAnchor.constraint(equalToConstant: 24),
            cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityNameLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 40)
        ]
            
        let favouriteButtonConstraint = [
            favouriteButton.heightAnchor.constraint(equalToConstant: 24),
            favouriteButton.widthAnchor.constraint(equalToConstant: 24),
            favouriteButton.leadingAnchor.constraint(equalTo: cityNameLabel.trailingAnchor, constant: 5),
            favouriteButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 40)
        ]
            
        let temperatureLabelConstraint = [
            tempertureLabel.heightAnchor.constraint(equalToConstant: 32),
            tempertureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempertureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10)
        ]
            
        let favouritesViewConstraints = [
            favouritesView.widthAnchor.constraint(equalToConstant: 300),
            favouritesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favouritesView.topAnchor.constraint(equalTo: tempertureLabel.bottomAnchor, constant: 40)
        ]
            
        let firstFavouriteItemConstraints = [
            firstFavouriteCityLabel.centerXAnchor.constraint(equalTo: favouritesView.centerXAnchor),
            firstFavouriteCityLabel.topAnchor.constraint(equalTo: favouritesView.topAnchor, constant: 20),
            firstFavouriteCityTemperatureLabel.centerXAnchor.constraint(equalTo: favouritesView.centerXAnchor),
            firstFavouriteCityTemperatureLabel.topAnchor.constraint(equalTo: firstFavouriteCityLabel.bottomAnchor, constant: 10)
        ]
            
        let secondFavouriteItemConstraints = [
            secondFavouriteCityLabel.centerXAnchor.constraint(equalTo: favouritesView.centerXAnchor),
            secondFavouriteCityLabel.topAnchor.constraint(equalTo: firstFavouriteCityTemperatureLabel.bottomAnchor, constant: 20),
            secondFavouriteCityTemperatureLabel.centerXAnchor.constraint(equalTo: favouritesView.centerXAnchor),
            secondFavouriteCityTemperatureLabel.topAnchor.constraint(equalTo: secondFavouriteCityLabel.bottomAnchor, constant: 10)
        ]
            
        let thirdFavouriteItemConstraints = [
            thirdFavouriteCityLabel.centerXAnchor.constraint(equalTo: favouritesView.centerXAnchor),
            thirdFavouriteCityLabel.topAnchor.constraint(equalTo: secondFavouriteCityTemperatureLabel.bottomAnchor, constant: 20),
            thirdFavouriteCityTemperatureLabel.centerXAnchor.constraint(equalTo: favouritesView.centerXAnchor),
            thirdFavouriteCityTemperatureLabel.topAnchor.constraint(equalTo: thirdFavouriteCityLabel.bottomAnchor, constant: 10),
            thirdFavouriteCityTemperatureLabel.bottomAnchor.constraint(equalTo: favouritesView.bottomAnchor, constant: -10)
        ]
            
       let showHistoryButtonConstraints = [
            showHistoryButton.heightAnchor.constraint(equalToConstant: 50),
            showHistoryButton.widthAnchor.constraint(equalToConstant: 300),
            showHistoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showHistoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
       ]
        
        NSLayoutConstraint.activate(weatherLabelConstraints + textFieldConstraints + cityNameLabelConstraints + favouriteButtonConstraint + temperatureLabelConstraint + favouritesViewConstraints + firstFavouriteItemConstraints + secondFavouriteItemConstraints + thirdFavouriteItemConstraints + showHistoryButtonConstraints)
    }
}

extension HomeScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}


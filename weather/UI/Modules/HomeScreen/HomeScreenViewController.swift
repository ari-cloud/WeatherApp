//
//  ViewController.swift
//  weather
//
//  Created by Арина Моргачева on 16.03.2023.
//

import UIKit
import RxSwift

class HomeScreenViewController: UIViewController {
    
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "What's the weather in"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2.0
        let color = UIColor.gray
        textField.layer.borderColor = color.cgColor
        return textField
    }()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.text = "London"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tempertureLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0°"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewModel = HomeScreenViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        view.addGestureRecognizer(tap)
        view.backgroundColor = .white
        view.addSubview(weatherLabel)
        view.addSubview(textField)
        view.addSubview(cityNameLabel)
        view.addSubview(tempertureLabel)
        
        setupLayoutConstraints()
        
        viewModel.cityName.bind(to: cityNameLabel.rx.text)
                 .disposed(by: disposeBag)
         
        viewModel.degrees.bind(to: tempertureLabel.rx.text)
                 .disposed(by: disposeBag)
        
        textField.rx.text.subscribe { text in
           self.viewModel.searchText.onNext(text)
           }
        .disposed(by: disposeBag)
        
    }
    
    func setupLayoutConstraints() {
        
        let constraints = [
            weatherLabel.heightAnchor.constraint(equalToConstant: 24),
            weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 10),
            
            cityNameLabel.heightAnchor.constraint(equalToConstant: 24),
            cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityNameLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 40),
            
            tempertureLabel.heightAnchor.constraint(equalToConstant: 32),
            tempertureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempertureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }

}

extension HomeScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
}


import UIKit
import RxSwift

class HomeScreenViewController: UIViewController, UIScrollViewDelegate {
    
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
        button.addTarget(nil, action: #selector(favouriteButtonAction), for: .touchUpInside)
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
    
    private let favouriteTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .gray
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let showHistoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("Show History", for: button.state)
        button.addTarget(nil, action: #selector(showHistoryButtonAction), for: .touchUpInside)
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
        bindFavouriteTableView()
        checkFavouriteIsEmpty()
        
        viewModel.weatherViewModel.subscribe(onNext: { [weak self] weather in
            guard let self else { return }
            DispatchQueue.main.async {
                self.cityNameLabel.text = weather.name
                self.tempertureLabel.text = weather.degrees
                guard let name = weather.name else { return }
                self.viewModel.historyItemsList.append(name)
                print(self.viewModel.historyItemsList)
                self.checkIfItemInFavourites(name: name)
            }
        })
        .disposed(by: disposeBag)
        
        viewModel.itemsForFavouriteTableView.onNext(viewModel.favouriteItems)
        
        textField.rx.text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
    }
    
    @objc func showHistoryButtonAction(sender: UIButton) {
        navigationController?.pushViewController(HistoryViewController(), animated: true)
    }
    
    @objc func favouriteButtonAction(sender: UIButton) {
        guard let name = self.cityNameLabel.text else { return }
        guard let temperature = self.tempertureLabel.text else { return }
        if sender.image(for: .normal) == UIImage(named: "favouriteIconNotChoosen") {
            viewModel.addToFavouriteItems(name: name, temperature: temperature, comletion: showTooManyAlert)
            sender.setImage(UIImage(named: "favouriteIconChoosen"), for: .normal)
        } else {
            viewModel.deleteFromFavouriteItems(name: name)
            sender.setImage(UIImage(named: "favouriteIconNotChoosen"), for: .normal)
        }
        reloadFavouriteTableView()
    }
    
    func reloadFavouriteTableView() {
        if viewModel.favouriteItems.isEmpty  {
            showEmptyAlert()
            self.favouriteTableView.isHidden = true
        } else {
            self.favouriteTableView.isHidden = false
            self.favouriteTableView.reloadData()
        }
    }
    
    func showTooManyAlert() {
        let alert = UIAlertController(title: "Favorites cannot contain more than three items. Delete item to continue", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showEmptyAlert() {
        let alert = UIAlertController(title: "Favorites is empty now.", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkIfItemInFavourites(name: String) {
        for item in viewModel.favouriteItems {
            if item.name == name {
                self.favouriteButton.setImage(UIImage(named: "favouriteIconChoosen"), for: .normal)
            } else {
                self.favouriteButton.setImage(UIImage(named: "favouriteIconNotChoosen"), for: .normal)
            }
        }
    }
    
    private func bindFavouriteTableView() {
        favouriteTableView.register(FavouritesTableViewCell.self, forCellReuseIdentifier: FavouritesTableViewCell.cellId)
        favouriteTableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.itemsForFavouriteTableView.bind(to: favouriteTableView.rx.items(cellIdentifier: FavouritesTableViewCell.cellId, cellType: FavouritesTableViewCell.self)){index, item, cell in
            cell.favouriteCityLabel.text = item.name
            cell.favouriteCityTemperatureLabel.text = item.temperature
        }.disposed(by: disposeBag)
    }
    
    func checkFavouriteIsEmpty() {
        if viewModel.favouriteItems.isEmpty {
            self.favouriteTableView.isHidden = true
        } else {
            self.favouriteTableView.isHidden = false
        }
    }
    
    private func setupLayoutConstraints() {
        view.addSubview(weatherLabel)
        view.addSubview(textField)
        view.addSubview(cityNameLabel)
        view.addSubview(favouriteButton)
        view.addSubview(tempertureLabel)
        view.addSubview(favouriteTableView)
        view.addSubview(showHistoryButton)
        
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
            
       let favouriteTableViewConstraints = [
            favouriteTableView.widthAnchor.constraint(equalToConstant: 300),
            favouriteTableView.heightAnchor.constraint(equalToConstant: 300),
            favouriteTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favouriteTableView.topAnchor.constraint(equalTo: tempertureLabel.bottomAnchor, constant: 40)
       ]
        
       let showHistoryButtonConstraints = [
            showHistoryButton.heightAnchor.constraint(equalToConstant: 50),
            showHistoryButton.widthAnchor.constraint(equalToConstant: 300),
            showHistoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showHistoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
       ]
        
        NSLayoutConstraint.activate(weatherLabelConstraints + textFieldConstraints + cityNameLabelConstraints + favouriteButtonConstraint + temperatureLabelConstraint + favouriteTableViewConstraints + showHistoryButtonConstraints)
    }
}

extension HomeScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}


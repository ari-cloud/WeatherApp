//
//  HomeScreenViewModel.swift
//  weather
//
//  Created by Арина Моргачева on 22.03.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class HomeScreenViewModel {
    var searchText = PublishSubject<String?>()
    var weatherViewModel = PublishSubject<WeatherViewModel>()
    
    lazy var favouriteItems: Results<WeatherFavouriteItem> = {self.realm.objects(WeatherFavouriteItem.self)}()
    let itemsForFavouriteTableView = PublishSubject<Results<WeatherFavouriteItem>>()

    let realm = StorageManager().realm
    
    private let networkManager = NetworkManager()
    private let storageManager = StorageManager()
    private let disposeBag = DisposeBag()
    
    init() {
        searchText
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] text in
                guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                self?.searchForWeather(with: text)
            }
            .disposed(by: disposeBag)
    }
    
    func addToFavouriteItems(name: String, temperature: String, comletion: @escaping () -> ()) {
        if self.favouriteItems.count < 3 {
            let item = WeatherFavouriteItem()
            item.name = name
            item.temperature = temperature
            self.storageManager.addToStorageManager(item: item)
            itemsForFavouriteTableView.onNext(self.favouriteItems)
            itemsForFavouriteTableView.onCompleted()
            print(self.favouriteItems)
        } else {
           comletion()
        }
        
    }

    func deleteFromFavouriteItems(name: String) {
        storageManager.clearStorageManager()
    }
    
    private func searchForWeather(with text: String) {
        NetworkManager().request(city: text, httpMethod: .get).subscribe(onNext: { data in
            self.decodeData(data: data)
        }, onError: {
            print($0.localizedDescription)
        }, onCompleted: {
            print("completed")
        })
        .disposed(by: self.disposeBag)
    }
    
    private func decodeData(data: Data) {
        let decoder = JSONDecoder()
        guard let weather = try? decoder.decode(Weather.self, from: data) else { return }
        self.weatherViewModel.onNext(WeatherViewModel(from: weather))
    }
}

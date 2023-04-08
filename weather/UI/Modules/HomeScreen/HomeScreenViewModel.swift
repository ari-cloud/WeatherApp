//
//  HomeScreenViewModel.swift
//  weather
//
//  Created by Арина Моргачева on 22.03.2023.
//

import Foundation
import RxSwift
import RxCocoa

class HomeScreenViewModel {
    var searchText = PublishSubject<String?>()
    var weatherViewModel = PublishSubject<WeatherViewModel>()
    
    var favouriteItems: [FavouriteItem] = []
    
    private let networkManager = NetworkManager()
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
    
    func addToFavouriteItems(name: String, temperature: String) {
        if self.favouriteItems.count < 3 {
            let item = FavouriteItem(name: name, temperature: temperature)
            self.favouriteItems.append(item)
        }
    }
    
    func deleteFromFavouriteItems(name: String) {
        var counter = 0
        for item in self.favouriteItems {
            counter += 1
            if name == item.name {
                favouriteItems.remove(at: counter)
            }
        }
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
    
    struct FavouriteItem {
        var name: String
        var temperature: String
    }
}

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
    
    let disposeBag = DisposeBag()
    
    var searchText = PublishSubject<String?>()
    
    var cityName = PublishSubject<String>()
    var degrees = PublishSubject<String>()
    
    var weather: Weather? {
       didSet {
          if let name = weather?.name {
             DispatchQueue.main.async {
                self.cityName.onNext(name)
             }
          }

          if let temp = weather?.degrees {
              DispatchQueue.main.async {
                self.degrees.onNext("\(temp)°F")
             }
          }
       }
    }

    init() {
        let jsonRequest = searchText.map { text in
            let url = URL(string: text ?? "http://api.openweathermap.org/data/2.5/weather?q=")
                return URLSession.shared.rx.json(request: URLRequest(url: url))
        }
            .switchLatest()
    
       jsonRequest
          .subscribe { json in
             self.weather = Weather(json: json)
           }
          .disposed(by: disposeBag)

    }

    
    private struct Constants {
        static let URLPrefix = "http://api.openweathermap.org/data/2.5/weather?q="
        static let URLPostfix = "/* my openweathermap APPID */"
    }

}

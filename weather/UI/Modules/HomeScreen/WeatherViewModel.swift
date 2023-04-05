//
//  WeatherViewModel.swift
//  weather
//
//  Created by Арина Моргачева on 05.04.2023.
//

import Foundation

struct WeatherViewModel {
    let name: String?
    let degrees: String
}

extension WeatherViewModel {
    init(from weather: Weather) {
        self.name = weather.name
        self.degrees = String(weather.main?.temp ?? 0.0)
    }
}

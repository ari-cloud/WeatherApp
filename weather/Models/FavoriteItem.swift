//
//  FavoriteItem.swift
//  weather
//
//  Created by Арина Моргачева on 08.04.2023.
//

import Foundation
import RealmSwift

class WeatherFavouriteItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var temperature: String = ""
}

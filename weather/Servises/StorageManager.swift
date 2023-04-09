//
//  StorageManager.swift
//  weather
//
//  Created by Арина Моргачева on 08.04.2023.
//

import Foundation
import RealmSwift

class StorageManager {
    
    let realm = try! Realm()
    
    func addToStorageManager(item: WeatherFavouriteItem) {
        try? realm.write {
            self.realm.add(item)
            print(realm.objects(WeatherFavouriteItem.self))
        }
    }
    
    func deleteFromStorageManager(item: WeatherFavouriteItem) {
        try? realm.write {
            self.realm.delete(item)
        }
    }
    
    func clearStorageManager() {
        try? realm.write {
            self.realm.deleteAll()
        }
    }
    
    func getFromStorageManager() {
        try? realm.write {
            
        }
    }
}

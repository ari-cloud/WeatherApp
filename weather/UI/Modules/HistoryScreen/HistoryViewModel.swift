//
//  HistoryViewModel.swift
//  weather
//
//  Created by Арина Моргачева on 06.04.2023.
//

import Foundation
import RxSwift

class HistoryViewModel {
    
    let itemsList: [String]
    let items = PublishSubject<[String]>()
    
    init(itemsList: [String]) {
        self.itemsList = itemsList
        items.onNext(itemsList)
    }
    
}

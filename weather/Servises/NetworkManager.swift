//
//  NetworkManager.swift
//  weather
//
//  Created by Арина Моргачева on 01.04.2023.
//

import Foundation
import RxSwift

class NetworkManager {
    func request(city: String, httpMethod: httpMethods) -> Observable<Data> {
        let urlValue = Constants.baseURL + "\(city)" + Constants.key
        guard let url = URL(string: urlValue) else { fatalError("Error with urlValue") }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return URLSession.shared.rx.data(request: request)
    }
    
    enum httpMethods: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case head = "HEAD"
        case delete = "DELETE"
        case connect  = "CONNECT"
        case options = "OPTIONS"
        case trace = "TRACE"
        case atch = "PATCH"
    }
    
    private struct Constants {
        static let baseURL = "https://api.openweathermap.org/data/2.5/weather?q="
        static let key = "&appid=66c71053eab46dbc9983e489189012a3"
    }
}



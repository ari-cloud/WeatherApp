//
//  WeatherModel.swift
//  weather
//
//  Created by Арина Моргачева on 22.03.2023.
//

import Foundation
import SwiftyJSON

class Weather {

   var name:String?
   var degrees:Double?
 
   init(json: AnyObject) {

      let data = JSON(json)
       
      self.name = data["name"].stringValue
      self.degrees = data["main"]["temp"].doubleValue

   }

}


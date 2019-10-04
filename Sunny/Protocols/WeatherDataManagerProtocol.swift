//
//  WeatherDataManagerProtocol.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 04..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

protocol WeatherDataManagerProtocol {
    typealias WeatherDataCompletionHandler = (Location?, [WeatherData]?, DataManagerError?) -> Void
    
    func weatherForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletionHandler)
}

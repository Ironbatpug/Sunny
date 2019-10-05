//
//  FetchWeatherDataImpl.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 05..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation

class FetchWeatherDataImpl: FetchDataServiceProtocol {
    private lazy var dataManager: WeatherDataManagering = {
        return WeatherDataManager(baseURL: API.urlForSixteenDayForecast, header: API.APIHeader)
    }()
    
    
    func fetchWeatherData(forLatitude latitude: Double, withLongitude longitude: Double) {
        dataManager.weatherForLocation(latitude: 47.7979, longitude: 19.0209) { (location, weather, dataError) in
            if let dataError = dataError {
                print(dataError)
            } else if let weather = weather, let location = location {
                
                DispatchQueue.main.async {
                    guard let weatherDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "WeatherDetailsViewController") as? WeatherDetailsViewController else { return }
                    weatherDetailsViewController.initData(forWeatherData: weather, witLocation: location)
                    self.present(weatherDetailsViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
}

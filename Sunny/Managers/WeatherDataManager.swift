//
//  WeatherDataManager.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 03..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation
import SwiftyJSON


enum DataManagerError: Error {
    
    case unknown
    case failedRequest
    case invalidResponse
    
}

final class WeatherDataManager : WeatherDataManagerProtocol {
    
    
    private let baseURL: String
    
    private let header: [String:String]
    
    init(baseURL: String, header: [String:String]) {
        self.baseURL = baseURL
        self.header = header
    }
    
    func weatherForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletionHandler) {
        let sessionConfiguration = URLSessionConfiguration.default
        
        var url = URLComponents(string: baseURL)
        url?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)")
        ]
        if let queryUrl = url?.url {
            var request = URLRequest(url:queryUrl)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = header
            let urlSession = URLSession(configuration:sessionConfiguration,
                                        delegate: nil, delegateQueue: nil)
            
            let sessionTask = urlSession.dataTask(with: request) {
                (data, response, error) in
                if let _ = error {
                    completion(nil, nil, .failedRequest)
                    
                } else if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        do {
                            let json = JSON(data: data)
                            
                            let weatherData = self.getWeatherDataArrayFromJSON(json: json)
                            let city = json["city_name"].stringValue
                            
                            
                            let location = Location(city: city, latitude: latitude, longitude: longitude)
                            completion(location, weatherData, nil)
                            
                        } catch {
                            completion(nil, nil, .invalidResponse)
                        }
                    } else {
                        completion(nil, nil, .failedRequest)
                    }
                    
                } else {
                    completion(nil, nil, .unknown)
                }
            }
            
            sessionTask.resume()
        }
    }
    
    private func getWeatherDataArrayFromJSON(json: JSON) -> [WeatherData] {
        var weatherResult: [WeatherData] = []
        for i in 0...15 {
            let data = json["data"].array![i]
            let nightTemperature = data["min_temp"].doubleValue
            let dayTemperature = data["max_temp"].doubleValue
            let sunset = data["sunset_ts"].doubleValue
            let sunrise = data["sunrise_ts"].doubleValue
            let weather = data["weather"]
            let icon = weather["icon"].stringValue
            
            let weatherDaily = WeatherData(sunriseDate: sunrise, sunsetDate: sunset, dayTemperature: dayTemperature, nightTemperature: nightTemperature, icon: icon)
            
            weatherResult.append(weatherDaily)
        }
        
        return weatherResult
    }
}

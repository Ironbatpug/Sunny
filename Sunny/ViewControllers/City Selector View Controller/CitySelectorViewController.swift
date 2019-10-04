//
//  ViewController.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 02..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class CitySelectorViewController: UIViewController {
    
    private lazy var dataService: WeatherDataManagerProtocol = {
        return WeatherDataManager(baseURL: API.urlForSixteenDayForecast, header: API.APIHeader)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchWeather() {
        dataService.weatherForLocation(latitude: 47.7979, longitude: 19.0209) { (location, weather, dataError) in
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

    @IBAction func searchForCurrentPositionWasPressed(_ sender: Any) {
        fetchWeather()
    }
    
}


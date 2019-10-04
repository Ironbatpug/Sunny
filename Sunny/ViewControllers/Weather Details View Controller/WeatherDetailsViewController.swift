//
//  WeatherDetailsViewController.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 04..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class WeatherDetailsViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!

    
    var weatherData : [WeatherData]?
    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        guard let location = self.location else {return}
        self.cityNameLabel.text = location.city
        if UserDefaults.containsLocation(location) {
            favoriteButton.setTitle("★", for: .normal)
        } else {
            favoriteButton.setTitle("☆", for: .normal)
        }
    }
    
    func initData(forWeatherData weatherData: [WeatherData], witLocation location: Location) {
        self.weatherData = weatherData
        self.location = location
    }
    
    @IBAction func setFavoriteButtonWasPressed(_ sender: Any) {
        guard let location = self.location else {return}
        if UserDefaults.containsLocation(location) {
            UserDefaults.removeLocation(location)
            favoriteButton.setTitle("☆", for: .normal)
        } else {
            UserDefaults.addLocation(location)
            favoriteButton.setTitle("★", for: .normal)
        }
    }
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension WeatherDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (weatherData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherData = weatherData, let cell = weatherTableView.dequeueReusableCell(withIdentifier: "WeatherDataTableViewCell") as? WeatherDataTableViewCell else {
            return UITableViewCell() }
        let weatherDayData = weatherData[indexPath.row]
        let sunRiseDate = weatherDayData.sunRiseDate
        let sunsetDate = weatherDayData.sunsetDate
        let dayTemperature = "\(weatherDayData.dayTemperature)"
        let nightTemperature = "\(weatherDayData.nightTemperature)"
        let icon = weatherDayData.icon
        
        cell.configureCell(maxTempeture: dayTemperature, minTempeture: nightTemperature, sunRise: sunRiseDate, sunSet: sunsetDate, weatherimageName: icon)
        return cell
    }
}










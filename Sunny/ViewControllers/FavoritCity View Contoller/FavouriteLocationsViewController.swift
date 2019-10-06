//
//  FavouriteLocationsViewController.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 04..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class FavouriteLocationsViewController: UIViewController {
    //MARK: connected ui elements
    @IBOutlet weak var favoriteTableView: UITableView!
    
    //MARK: Variables and constants
    
    var cities = [Location]()

    private lazy var dataService: WeatherDataManager = {
        return WeatherDataManager(baseURL: API.urlForSixteenDayForecast, header: API.APIHeader)
    }()
    
    //MARK: Viewcontroller Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
    }
    
    func initData(forLocations locations: [Location]) {
        cities = locations
    }
    
    //MARK: helpers for weather fetch
    
    private func fetchWeather(forLatitude latitude: Double, withLogitude longitude: Double) {
        dataService.weatherForLocation(latitude: latitude, longitude: longitude) { (location, weather, dataError) in
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
    
    //MARK: Button actions
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: TableView delegation and datasource

extension FavouriteLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCityTableViewCell") as? FavoriteCityTableViewCell else { return UITableViewCell()}
        let location = cities[indexPath.row]
        let cityName = location.city
        cell.configureCell(cityName: cityName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = cities[indexPath.row]
        
        fetchWeather(forLatitude: location.latitude, withLogitude: location.longitude)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            UserDefaults.removeLocation(self.cities[indexPath.row])
            self.cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.8786954659, green: 0.2403508394, blue: 0.2190680203, alpha: 1)
        
        return [deleteAction]
    }
}

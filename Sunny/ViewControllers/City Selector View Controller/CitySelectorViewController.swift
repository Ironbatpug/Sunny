//
//  ViewController.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 02..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit
import CoreLocation

class CitySelectorViewController: UIViewController {
    @IBOutlet weak var favoriteCitesButton: UIButton!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    
    private var currentLocation: CLLocation?
    

    var filteredLocation = [Location]()
    
    var cities = [
    Location(city: "Budapest", latitude: 47.4979, longitude: 19.0402),
        Location(city: "New York", latitude: 47.4979, longitude: 19.0402),
        Location(city: "Miskolc", latitude: 47.4979, longitude: 19.0402),
        Location(city: "Debrecen", latitude: 47.4979, longitude: 19.0402),
        Location(city: "London", latitude: 47.4979, longitude: 19.0402),
        Location(city: "Paris", latitude: 47.4979, longitude: 19.0402),
        Location(city: "Milano", latitude: 47.4979, longitude: 19.0402),
        Location(city: "Tiszalúc", latitude: 47.4979, longitude: 19.0402)
    ]
    
    private lazy var geoService: GeocodeDecoder = {
        return GeocodeLocationService()
    }()
    
    private lazy var dataService: WeatherDataManagerProtocol = {
        return WeatherDataManager(baseURL: API.urlForSixteenDayForecast, header: API.APIHeader)
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        
        locationManager.distanceFilter = 1000.0
        locationManager.desiredAccuracy = 1000.0
        
        return locationManager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocation()
        cityTableView.delegate = self
        cityTableView.dataSource = self
        
        citySearchBar.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.loadLocations().isEmpty{
            favoriteCitesButton.isHidden = true
        } else {
            favoriteCitesButton.isHidden = false
        }
    }
    
    private func requestLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
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
    
    private func fetchWeather(forCityName city: String) {
        geoService.geocode(addressString: city) { (location, error) in
            if let error = error {
                debugPrint("could not determine the address")
            } else {
                self.fetchWeather(forLatitude: (location?.latitude)!, withLogitude: (location?.longitude)!)
            }
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return citySearchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredLocation = cities.filter({( location : Location) -> Bool in
            return location.city.lowercased().contains(searchText.lowercased())
        })
        
        cityTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }

    @IBAction func searchForCurrentPositionWasPressed(_ sender: Any) {
            guard let location = currentLocation else { return }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            fetchWeather(forLatitude: latitude, withLogitude: longitude)
    }
    
    
    @IBAction func viewFavoriteCitesBtnWasPressed(_ sender: Any) {
        let locations = Array(UserDefaults.loadLocations())
        print(locations)
        if !locations.isEmpty {
            guard let favouriteLocationsViewController = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteLocationsViewController") as? FavouriteLocationsViewController else { return }
            favouriteLocationsViewController.initData(forLocations: locations)
            self.present(favouriteLocationsViewController, animated: true, completion: nil)
        }
    }
}

extension CitySelectorViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            
            manager.delegate = nil
            
            manager.stopUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if currentLocation == nil {
            let alertVC = UIAlertController(title: "Can not determine your Location", message: "The app can not determine your location, try searching for a city.", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertVC.addAction(cancelAction)
            present(alertVC,animated: true, completion: nil)
        }
    }
}

extension CitySelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredLocation.count
        }
        
        return cities.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location: Location
        
        print(isFiltering())
        if isFiltering() {
            print("true")
            location = filteredLocation[indexPath.row]
            fetchWeather(forCityName: location.city)
        } else {
            location = cities[indexPath.row]
            fetchWeather(forCityName: location.city)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell") as? CityTableViewCell else { return UITableViewCell()}
        let location: Location
        if isFiltering() {
            location = filteredLocation[indexPath.row]
        } else {
            location = cities[indexPath.row]
        }
        let cityName = location.city
        cell.configureCell(cityName: cityName)
        return cell
    }
    
    
}

extension CitySelectorViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(citySearchBar.text!)

    }
}





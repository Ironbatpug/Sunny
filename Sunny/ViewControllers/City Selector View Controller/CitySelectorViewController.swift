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
    //MARK: connected ui elements
    @IBOutlet weak var favoriteCitesButton: UIButton!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    
    //MARK: Variables and constants
    private var currentLocation: CLLocation?
    
    var filteredLocation = [Location]()
    
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
    
    //MARK: Viewcontroller Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocation()
        cityTableView.delegate = self
        cityTableView.dataSource = self
        citySearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: permission ask
    private func requestLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
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
    
    private func fetchWeather(forCityName city: String) {
        geoService.geocode(addressString: city) { (location, error) in
            if let error = error {
                debugPrint("could not determine the address: \(error)")
            } else {
                self.fetchWeather(forLatitude: (location?.latitude)!, withLogitude: (location?.longitude)!)
            }
        }
    }
    
    //Mark: serachbar
    func searchBarIsEmpty() -> Bool {
        return citySearchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        geoService.geocode(addressString: searchText) { (location, error) in
            if let error = error {
                debugPrint("could not determine the address: \(error)")
            } else {
                guard let location = location else { return }
                self.filteredLocation = [location]
            }
        }
        cityTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
    
    //MARK: Button actions
    @IBAction func searchForCurrentPositionWasPressed(_ sender: Any) {
        guard let location = currentLocation else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        fetchWeather(forLatitude: latitude, withLogitude: longitude)
    }
    
    @IBAction func viewFavoriteCitesBtnWasPressed(_ sender: Any) {
        if UserDefaults.loadLocations().isEmpty{
            let alertVC = UIAlertController(title: "You do not have any favorites cities", message: "This is where you could see your favorites a cities. After you search for city you can add it to your favorites by clicking on the star.", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(cancelAction)
            present(alertVC,animated: true, completion: nil)
        } else {
            let locations = Array(UserDefaults.loadLocations())
            
            guard let favouriteLocationsViewController = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteLocationsViewController") as? FavouriteLocationsViewController else { return }
            favouriteLocationsViewController.initData(forLocations: locations)
            self.present(favouriteLocationsViewController, animated: true, completion: nil)
        }
    }
}

//MARK: LocationManager

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
            let alertVC = UIAlertController(title: "Can not determine your Location", message: "The app can not determine your location right now, try searching for a city.", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(cancelAction)
            present(alertVC,animated: true, completion: nil)
        }
    }
}

//MARK: Tableview
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
        if isFiltering() {
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

//MARK: serachbardelegate

extension CitySelectorViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(citySearchBar.text!)
    }
}





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
    
    private var currentLocation: CLLocation?

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

extension UISearchDisplayDelegate {
    
}






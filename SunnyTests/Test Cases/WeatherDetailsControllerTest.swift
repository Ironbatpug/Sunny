//
//  SunnyTests.swift
//  SunnyTests
//
//  Created by Molnár Csaba on 2019. 10. 02..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Sunny

class WeatherDetailsControllerTest: XCTestCase {
    
    var viewController : WeatherDetailsViewController!
    
    override func setUp() {
        super.setUp()
        
        let dateFromFile = loadStubFromBundle(withName: "testData", extension: "json")
        let json = JSON(data: dateFromFile)
        var weatherResult = [WeatherData]()
        
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
        let location = Location(city: "Dunabogdány", latitude: 47.799999999999997, longitude: 19.02)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "WeatherDetailsViewController") as! WeatherDetailsViewController
        viewController.initData(forWeatherData: weatherResult, witLocation: location)
        viewController.loadViewIfNeeded()
        
    }
    
    override func tearDown() {
        super.tearDown()
        viewController = nil
        UserDefaults.standard.removeObject(forKey: "locations")
    }
    
    func testTitle() {
        XCTAssertEqual(viewController.cityNameLabel.text, "Dunabogdány")
    }
    
    func testFavoritButtonWasPressed() {
        viewController.favoriteButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(viewController.favoriteButton.titleLabel?.text, "★")
        XCTAssertFalse(UserDefaults.loadLocations().isEmpty)
    }
    
    func testFavoritButtonWasPressedTwice() {
        viewController.favoriteButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(viewController.favoriteButton.titleLabel?.text, "★")
        XCTAssertFalse(UserDefaults.loadLocations().isEmpty)
        viewController.favoriteButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(viewController.favoriteButton.titleLabel?.text, "☆")
        XCTAssertTrue(UserDefaults.loadLocations().isEmpty)
    }
    
}

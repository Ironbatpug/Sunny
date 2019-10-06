//
//  WeatherDataManagerTest.swift
//  SunnyTests
//
//  Created by Molnár Csaba on 2019. 10. 06..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import XCTest
@testable import Sunny

class WeatherDataManagerTest: XCTestCase {
    
    private lazy var dataService: WeatherDataManagerProtocol = {
        return WeatherDataManager(baseURL: API.urlForSixteenDayForecast, header: API.APIHeader)
    }()
    var weatherResult: [WeatherData]?
    var locationResult: Location?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWeathermanager() {
        let weatherExpectation = self.expectation(description: "weather")
        
        dataService.weatherForLocation(latitude: 47.799999999999997, longitude: 19.02) { (location, weather, error) in
            if let _ = error {
                XCTFail()
            } else {
                guard let location = location, let weather = weather else {
                    XCTFail()
                    return
                }
                self.weatherResult = weather
                self.locationResult = location
                weatherExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(weatherResult?.count, 16)
        XCTAssertEqual(locationResult?.city, "Dunabogdány")
        
        
    }
    
}

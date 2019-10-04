//
//  WeatherData.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 02..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation

struct WeatherData {
    let sunRiseDate: Date
    let sunsetDate: Date
    let dayTemperature: Double
    let nightTemperature: Double
    let icon: String
    
    init(sunriseDate: Double, sunsetDate: Double, dayTemperature: Double, nightTemperature: Double, icon: String) {
        self.sunRiseDate = Date(timeIntervalSince1970: sunriseDate)
        self.sunsetDate = Date(timeIntervalSince1970: sunsetDate)

        self.dayTemperature = dayTemperature
        self.nightTemperature = nightTemperature
        self.icon = icon
    }
}

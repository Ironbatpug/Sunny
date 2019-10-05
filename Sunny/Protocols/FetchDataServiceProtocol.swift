//
//  fetchDataService.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 05..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation

protocol FetchDataServiceProtocol {
    func fetchWeatherData(forLatitude latitude: Double, withLongitude longitude: Double)
}

//
//  Configuration.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 02..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation


struct API {
    
    static let APIHost = "weatherbit-v1-mashape.p.rapidapi.com"
    static let APIKey = "44a67801fdmsh215356437ad52b9p19293cjsn4a05804d6421"
    static let urlForSixteenDayForecast = "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/daily/"
    
    static let APIHeader =  [
        "x-rapidapi-host": APIHost,
        "x-rapidapi-key":APIKey
    ]
}

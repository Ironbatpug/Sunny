//
//  Location.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 02..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation

struct  Location : Hashable{
    let city : String
    let latitude: Double
    let longitude: Double
    
    var asDictionary: [String: Any] {
        return [ "city": city,
                 "latitude" : latitude,
                 "longitude": longitude ]
    }
    
    init(city: String, latitude: Double, longitude: Double) {
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(dictionary: [String: Any]) {
        guard let city = dictionary["city"] as? String else { return nil }
        guard let latitude = dictionary["latitude"] as? Double else { return nil }
        guard let longitude = dictionary["longitude"] as? Double else { return nil }
        
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
    }
}

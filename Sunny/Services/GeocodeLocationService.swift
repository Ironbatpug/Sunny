//
//  GeocodeLocationService.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 05..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation
import CoreLocation

class GeocodeLocationService: GeocodeDecoder {    
    private lazy var geocoder = CLGeocoder()

    
    
    func geocode(addressString: String, completionHandler: @escaping GeocodeDecoder.LocationServiceCompletionHandler) {
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let placemarks = placemarks {
                let placemark = placemarks.first
                let city = placemark?.name
                let latitude = placemark?.location?.coordinate.latitude
                let longitude = placemark?.location?.coordinate.longitude
                let location = Location(city: city!, latitude: latitude!, longitude: longitude!)
                completionHandler(location, nil)
            }
        }
        
    }
    
    
}

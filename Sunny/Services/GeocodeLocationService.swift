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
    static let instance = GeocodeLocationService()
    
    private lazy var geocoder = CLGeocoder()

    
    
    func geocode(addressString: String, completionHandler: @escaping GeocodeDecoder.LocationServiceCompletionHandler) {
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                completionHandler([], error)
            } else if let placemarks = placemarks {
                debugPrint(placemarks)
            }
        }
        
    }
    
    
}

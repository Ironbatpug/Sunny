//
//  GeocodeDecoder.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 04..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

protocol GeocodeDecoder {
    typealias LocationServiceCompletionHandler = (Location?, Error?) -> Void
    
    func geocode(addressString: String, completionHandler: @escaping LocationServiceCompletionHandler)
}

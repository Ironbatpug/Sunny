//
//  UserDefaults.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 04..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation

struct UserDefaultsKey {
    static let locations = "locations"
}


extension UserDefaults {
    
    static func loadLocations() -> Set<Location> {
        guard let dictionaries = UserDefaults.standard.array(forKey: UserDefaultsKey.locations) as? [ [String: Any] ] else {
            return []
        }
        let locationArray = dictionaries.compactMap({ (dictionary) -> Location? in
            return Location(dictionary: dictionary)
        })
        return Set(locationArray)
    }
    
    static func addLocation(_ location: Location) {
        if !UserDefaults.containsLocation(location){
            var locations = loadLocations()
            locations.insert(location)
            print(locations)
            saveLocations(locations)
        }
    }
    
    static func removeLocation(_ location: Location) {
        var locations = loadLocations()
        locations.remove(location)
        
        saveLocations(locations)
    }
    
    static func containsLocation(_ location: Location) -> Bool {
        let locations = loadLocations()

        return locations.contains(location)
    }
    
    private static func saveLocations(_ locations: Set<Location>) {
        let locations: [ [String: Any] ] = locations.map{ $0.asDictionary }
        UserDefaults.standard.set(locations, forKey: UserDefaultsKey.locations)
    }

}


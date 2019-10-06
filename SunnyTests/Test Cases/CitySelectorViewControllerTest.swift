//
//  CitySelectorViewControllerTest.swift
//  SunnyTests
//
//  Created by Molnár Csaba on 2019. 10. 06..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import XCTest
@testable import Sunny

class CitySelectorViewControllerTest: XCTestCase {
    
    var viewController : CitySelectorViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        viewController = storyboard.instantiateViewController(withIdentifier: "CitySelectorViewController") as! CitySelectorViewController
        viewController.loadViewIfNeeded()
        let location = Location(city: "Dunabogdány", latitude: 47.799999999999997, longitude: 19.02)
        UserDefaults.addLocation(location)
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.removeObject(forKey: "locations")
        viewController = nil
    }
    
    func testFavoriteStarShowing() {
        XCTAssertFalse(viewController.favoriteCitesButton.isHidden)
    }
    
}

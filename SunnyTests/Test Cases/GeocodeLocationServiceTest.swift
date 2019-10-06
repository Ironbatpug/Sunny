//
//  GeocodeLocationServiceTest.swift
//  SunnyTests
//
//  Created by Molnár Csaba on 2019. 10. 06..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import XCTest
@testable import Sunny

class GeocodeLocationServiceTest: XCTestCase {
    private lazy var geoService: GeocodeDecoder = {
        return GeocodeLocationService()
    }()
    
    var locationAssert: Location?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGeocodeReceving() {
        let locationExpectation = self.expectation(description: "location")
        geoService.geocode(addressString: "Budape") { (location, error) in
            if let _ = error {
                XCTFail()
                locationExpectation.fulfill()
            } else {
                guard let location = location else {
                    XCTFail()
                    return
                }
                self.locationAssert = location
                locationExpectation.fulfill()

            }
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual("Budapest", self.locationAssert?.city)

    }
    
}

//
//  XtestCase.swift
//  SunnyTests
//
//  Created by Molnár Csaba on 2019. 10. 06..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    // MARK: - Helper Methods
    
    func loadStubFromBundle(withName name: String, extension: String) -> Data {
        let bundle = Bundle(for: classForCoder)
        let url = bundle.url(forResource: name, withExtension: `extension`)
        
        return try! Data(contentsOf: url!)
    }
    
}

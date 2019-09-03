//
//  ChallengeServiceTests.swift
//  ChallengeServiceTests
//
//  Created by Marcelo Bogdanovicz on 02/09/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import XCTest
@testable import Challenge

class ChallengeServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testSearch() {
        
        Services.suggestions(query: "Portugal", prox: nil) { (suggestions, _) in
            
            XCTAssertTrue(suggestions != nil)
            XCTAssertFalse(suggestions!.suggestions.isEmpty)
            XCTAssertEqual(suggestions!.suggestions[0].locationId, "NT_awMja08ldnoS9wpQpZAGJB")
        }
    }
    
    func testDetails() {
        
        Services.details(locationId: "NT_awMja08ldnoS9wpQpZAGJB", prox: nil) { (result, _) in
            
            XCTAssertTrue(result != nil)
            XCTAssertEqual(result!.location.displayPosition.latitude, 38.72639)
            XCTAssertEqual(result!.location.displayPosition.longitude, -9.14949)
            XCTAssertEqual(result!.location.address.country, "Portugal")
        }
    }
}

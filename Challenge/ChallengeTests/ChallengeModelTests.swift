//
//  ChallengeModelTests.swift
//  ChallengeModelTests
//
//  Created by Marcelo Bogdanovicz on 31/08/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import XCTest
@testable import Challenge

class ChallengeModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    func fileURL(filename: String) -> URL? {
        let bundle = Bundle(for: type(of: self))
        return bundle.url(forResource: filename, withExtension: "json")
    }
    
    func testSuggestionsMapping() throws {
        guard let url = fileURL(filename: "Suggestions") else {
            XCTFail("Missing file: Characters.json")
            return
        }
        
        let jsonData = try Data(contentsOf: url)
        let model = try JSONDecoder().decode(Suggestions.self, from: jsonData)
        
        XCTAssertEqual(model.suggestions[0].locationId, "NT_Nbkhx1r9esGYAhcYiq.0xC")
        XCTAssertEqual(model.suggestions[1].address.postalCode, "84010-160")
    }
    
    func testLocationDetailsMapping() throws {
        guard let url = fileURL(filename: "LocationDetails") else {
            XCTFail("Missing file: Characters.json")
            return
        }
        
        let jsonData = try Data(contentsOf: url)
        let location = try JSONDecoder().decode(Location.self, from: jsonData)
        let result = location.response.view[0].result[0]
        
        XCTAssertEqual(result.location.locationId, "NT_Nbkhx1r9esGYAhcYiq.0xC")
        XCTAssertEqual(result.distance, 89.9)
    }

    private func loadLocation() -> LocationDetails {
        let displayPosition = Position(latitude: 38.72639, longitude: -9.14949)
        let topLeft = Position(latitude: 42.15412, longitude: -9.54666)
        let bottomRight = Position(latitude: 36.96172, longitude: -6.18931)
        let mapView = MapView(topLeft: topLeft, bottomRight: bottomRight)
        let address = Address(label: "Portugal", country: "PRT")
        
        return LocationDetails(locationId: "NT_awMja08ldnoS9wpQpZAGJB", locationType: "area", displayPosition: displayPosition, mapView: mapView, address: address)
    }
    
    func testAddToFavorite() {
        
        let locationDetails = loadLocation()
        Favorite.addToFavorite(locationDetails)

        XCTAssertTrue(Favorite.isFavorite(locationDetails.locationId))
    }
    
    func testRemoveFromFavorite() {
        
        let locationDetails = loadLocation()
        Favorite.removeFromFavorite(locationDetails)
        
        XCTAssertFalse(Favorite.isFavorite(locationDetails.locationId))
    }

}

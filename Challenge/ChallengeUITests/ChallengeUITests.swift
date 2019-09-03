//
//  ChallengeUITests.swift
//  ChallengeUITests
//
//  Created by Marcelo Bogdanovicz on 31/08/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import XCTest

class ChallengeUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
    }
    
    func test1Home() {
        app.launchArguments = ["-reset"]
        app.launch()
        
        let isDisplaying = app.tables["Home"].exists
        XCTAssertTrue(isDisplaying)
    }
    
    func test2Search() {
        let app = XCUIApplication()
        
        let searchBarElement = app.searchFields.element
        
        searchBarElement.tap()
        searchBarElement.typeText("Portugal")
    }
    
    func test3Detail() {
        let cell = app.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))

        cell.tap()
        
        let detailView = app.otherElements["Details"]
        XCTAssertTrue(detailView.waitForExistence(timeout: 3))
    }

    func test4AddToFavorite() {
        let button = app.buttons.element(boundBy: 2)
        
        XCTAssertFalse(button.isSelected)
        button.tap()
        XCTAssertTrue(button.isSelected)
    }
    
    func test5FavoriteList() {
        let back = app.buttons.element(boundBy: 0)
        back.tap()
        
        let home = app.tables["Home"]
        XCTAssertTrue(home.waitForExistence(timeout: 3))
        
        let favoriteCell = home.cells["FavoriteCell"]
        let maxScrolls = 10
        var count = 0
        while favoriteCell.isHittable == false && count < maxScrolls {
            app.swipeUp()
            count += 1
        }
        
        favoriteCell.tap()
        
        let favoritesView = app.otherElements["Favorites"]
        XCTAssertTrue(favoritesView.waitForExistence(timeout: 3))
        
        let cancel = app.buttons.element(boundBy: 0)
        cancel.tap()
        
        app.terminate()
    }
}

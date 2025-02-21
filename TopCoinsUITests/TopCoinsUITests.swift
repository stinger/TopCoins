//
//  TopCoinsUITests.swift
//  TopCoinsUITests
//
//  Created by Ilian Konchev on 19.02.25.
//

import XCTest

final class TopCoinsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testMainViewControllerNavigation() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-useMockData", "-useMockDefaults"]
        app.launch()

        let tabBar = app.tabBars["Tab Bar"]
        let topCoinsButton = tabBar.buttons["Top Coins"]
        let favouritesButton = tabBar.buttons["Favourites"]
        let collectionViewsQuery = app.collectionViews

        topCoinsButton.tap()

        let topCoinsNavigationBar = app.navigationBars["Top Coins"]
        XCTAssertTrue(topCoinsNavigationBar.staticTexts["Top Coins"].exists)
        XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 5)

        favouritesButton.tap()

        let favouritesNavigationBar = app.navigationBars["Favourites"]
        XCTAssertTrue(favouritesNavigationBar.staticTexts["Favourites"].exists)
        XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 0)

        topCoinsButton.tap()

        collectionViewsQuery
            .children(matching: .cell).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 1)
            .tap()

        let item = collectionViewsQuery.staticTexts["Name, Bitcoin"]

        XCTAssertTrue(item.exists)
        item.tap()

        let bitcoinNavigationBar = app.navigationBars["Bitcoin"]
        XCTAssertTrue(bitcoinNavigationBar.staticTexts["Bitcoin"].exists)
    }

    @MainActor func testFavouriteBookmarking() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-useMockData", "-useMockDefaults"]
        app.launch()

        let tabBar = app.tabBars["Tab Bar"]
        let topCoinsButton = tabBar.buttons["Top Coins"]
        let favouritesButton = tabBar.buttons["Favourites"]

        let collectionViewsQuery = app.collectionViews

        favouritesButton.tap()

        XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 0)

        topCoinsButton.tap()

        // favourite first element
        collectionViewsQuery.children(matching: .cell)
            .element(boundBy: 0)
            .children(matching: .other)
            .element(boundBy: 1)
            .swipeLeft()

        collectionViewsQuery.buttons["Favourite"].tap()

        favouritesButton.tap()

        XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 1)

        // unfavourite first element
        collectionViewsQuery.children(matching: .cell)
            .element(boundBy: 0)
            .children(matching: .other)
            .element(boundBy: 1)
            .swipeLeft()

        collectionViewsQuery.buttons["Unfavourite"].tap()

        XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 0)
    }

    @MainActor func testFavouritesNavigation() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-useMockData", "-useMockDefaults"]
        app.launch()

        // favourite an item
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery
            .children(matching: .cell).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 1)
            .swipeLeft()

        collectionViewsQuery.buttons["Favourite"].tap()
        app.tabBars["Tab Bar"].buttons["Favourites"].tap()

        collectionViewsQuery.cells
            .children(matching: .other)
            .element(boundBy: 1).tap()

        XCTAssertTrue(app.navigationBars["Bitcoin"].staticTexts["Bitcoin"].exists)
    }

    @MainActor func testSearch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-useMockData", "-useMockDefaults"]
        app.launch()

        let topCoinsNavigationBar = app.navigationBars["Top Coins"]
        let collectionViewsQuery = app.collectionViews

        XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 5)

        let filterByNameSearchField = topCoinsNavigationBar.searchFields["Filter by name"]
        filterByNameSearchField.tap()
        filterByNameSearchField.typeText("Bit")

        XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 1)

        filterByNameSearchField.buttons["Clear text"].tap()

        XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 5)

        topCoinsNavigationBar.buttons["Cancel"].tap()

        XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 5)
    }
}

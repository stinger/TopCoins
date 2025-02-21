//
//  FavouritesCoordinatorTests.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import XCTest

@testable import TopCoins

final class FavouritesCoordinatorTests: XCTestCase {
    func testCoordinatorInit() {
        let sut = FavouritesCoordinator(userDefaults: .mock, urlSession: .mock)

        XCTAssertEqual(sut.navigationController?.viewControllers.count, 1)
        XCTAssertTrue(sut.navigationController is AppNavigationController)
        XCTAssertTrue(sut.navigationController?.topViewController is FavouritesViewController)
    }

    func testCoordinatorShowsDetails() {
        let sut = FavouritesCoordinator(userDefaults: .mock, urlSession: .mock)
        sut.showDetails(for: .bitcoin)

        XCTAssertEqual(sut.navigationController?.viewControllers.count, 2)
        XCTAssertTrue(sut.navigationController?.topViewController is CoinDetailsViewController)
    }
}

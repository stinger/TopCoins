//
//  MainCoordinatorTests.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import XCTest

@testable import TopCoins

final class MainCoordinatorTests: XCTestCase {
    func testCoordinatorInit() {
        let sut = MainCoordinator(urlSession: .mock)

        XCTAssertEqual(sut.navigationController?.viewControllers.count, 1)
        XCTAssertTrue(sut.navigationController is AppNavigationController)
        XCTAssertTrue(sut.navigationController?.topViewController is MainViewController)
    }

    func testCoordinatorShowsDetails() {
        let sut = MainCoordinator(urlSession: .mock)
        sut.showDetails(for: .bitcoin)

        XCTAssertEqual(sut.navigationController?.viewControllers.count, 2)
        XCTAssertTrue(sut.navigationController?.topViewController is CoinDetailsViewController)
    }
}

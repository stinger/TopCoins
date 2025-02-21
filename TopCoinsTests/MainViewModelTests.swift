//
//  MainViewControllerTests.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import Combine
import XCTest

@testable import TopCoins

final class MainViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func testAPIDataFetchingAndParsing() throws {
        let sut = MainViewModel(urlSession: .mock)

        let expectation = XCTestExpectation(description: "Wait for the data")
        var expectedCoins: [Coin] = []

        sut.$coins
            .dropFirst(1)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { value in
                expectedCoins = value
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchCoins()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertFalse(expectedCoins.isEmpty)
        XCTAssertEqual(expectedCoins.count, 5)
        XCTAssertEqual(expectedCoins[0], Coin.bitcoin)
    }
}

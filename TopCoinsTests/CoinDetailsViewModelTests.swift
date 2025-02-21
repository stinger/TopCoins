//
//  CoinDetailsViewModelTests.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import Combine
import XCTest

@testable import TopCoins

final class CoinDetailsViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func testAPIDataFetchingAndParsing() throws {
        let sut = CoinDetailsViewModel(coin: .bitcoin, urlSession: .mock)

        let expectation = XCTestExpectation(description: "Wait for the data")
        var expectedHistory: [CoinHistoryEntry] = []

        sut.$history
            .dropFirst(1)
            .filter { !$0.isEmpty }
            .sink { value in
                expectedHistory = value
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchCoinHistory()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertFalse(expectedHistory.isEmpty)
        XCTAssertEqual(expectedHistory.count, 60)
    }
}

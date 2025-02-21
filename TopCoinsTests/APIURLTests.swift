//
//  APIURLTests.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import XCTest

@testable import TopCoins

final class APIURLTests: XCTestCase {
    func testCoinsRequest() {
        for orderFilter in CoinSorter.allCases {
            let offset = Int.random(in: 0 ... 80)
            let limit = Int.random(in: 20 ... 40)
            let sut = APIURL.coins(limit, offset, orderFilter).request

            XCTAssertNotNil(sut)
            XCTAssertEqual(sut?.httpMethod, "GET")
            XCTAssertEqual(sut?.allHTTPHeaderFields?["x-access-token"], APIConfiguration.apiKey)
            XCTAssertEqual(
                sut?.url?.absoluteString,
                "https://api.coinranking.com/v2/coins?limit=\(limit)&offset=\(offset)&orderBy=\(orderFilter.rawValue)"
            )
        }
    }

    func testCoinHistoryRequest() {
        for timespan in Timespan.allCases {
            let sut = APIURL.history("fake", timespan).request

            XCTAssertNotNil(sut)
            XCTAssertEqual(sut?.httpMethod, "GET")
            XCTAssertEqual(sut?.allHTTPHeaderFields?["x-access-token"], APIConfiguration.apiKey)
            XCTAssertEqual(
                sut?.url?.absoluteString,
                "https://api.coinranking.com/v2/coin/fake/history?timePeriod=\(timespan.rawValue)"
            )
        }
    }
}

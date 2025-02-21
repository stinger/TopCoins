//
//  FavouritesViewModelTests.swift
//  TopCoinsTests
//
//  Created by Ilian Konchev on 19.02.25.
//

import XCTest

@testable import TopCoins

final class FavouritesViewModelTests: XCTestCase {
    func testFavouriteAddRemove() throws {
        let sut = FavouritesViewModel(storage: .mock)

        let coin = Coin.bitcoin

        XCTAssertEqual(sut.favourites.count, 0)

        sut.addToFavourite(coin: coin)

        XCTAssertEqual(sut.favourites.count, 1)
        XCTAssertTrue(sut.favourites.contains(coin))

        sut.removeFromFavourite(coin: coin)

        XCTAssertEqual(sut.favourites.count, 0)
    }

    func testFavouriteLoading() throws {
        let model = FavouritesViewModel(storage: .mock)
        let sut = FavouritesViewModel(storage: .mock)

        let coin = Coin.bitcoin

        model.addToFavourite(coin: coin)

        sut.loadFavourites()

        XCTAssertEqual(sut.favourites.count, 1)
        XCTAssertTrue(sut.favourites.contains(coin))
    }
}

//
//  Coin+Fake.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Foundation

extension Coin {
    static let bitcoin: Self = .init(
        uuid: "Qwsogvtv82FCd",
        symbol: "BTC",
        name: "Bitcoin",
        change: "1.26",
        iconUrl: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg",
        price: "98235.33136269842",
        performance: "27474028873",
        listedAt: Date(timeIntervalSince1970: 1330214400.0)
    )
}

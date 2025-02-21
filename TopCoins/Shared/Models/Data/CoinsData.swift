//
//  CoinsData.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Foundation

struct CoinsData: Codable {
    var coins: [Coin]
    var stats: CoinStats
}

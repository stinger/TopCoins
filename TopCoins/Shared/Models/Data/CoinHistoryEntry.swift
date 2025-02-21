//
//  CoinHistoryEntry.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Foundation

struct CoinHistoryEntry: Codable {
    let price: String?
    let timestamp: Date

    var priceDouble: Double {
        guard let price else { return 0 }
        return Double(price) ?? 0
    }
}

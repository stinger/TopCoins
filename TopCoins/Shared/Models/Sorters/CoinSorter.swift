//
//  CoinSorter.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Foundation

enum CoinSorter: String, CaseIterable, CustomStringConvertible {
    case price, marketCap
    case volume = "24hVolume"
    case change

    var description: String {
        switch self {
        case .price:
            return "Price"
        case .marketCap:
            return "Market Cap"
        case .volume:
            return "24H Volume"
        case .change:
            return "Change"
        }
    }
}

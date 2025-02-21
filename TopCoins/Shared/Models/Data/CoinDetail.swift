//
//  CoinDetail.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Foundation

public struct CoinDetail: Hashable {
    let name: String
    let value: String

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

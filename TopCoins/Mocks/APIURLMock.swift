//
//  APIURLMock.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import Foundation

protocol APIURLMock: CaseIterable, Sendable {
    var apiURL: APIURL { get }
    var responseCode: Int { get }
    var fileName: String? { get }
}

enum CoinbaseAPIURLMock: String, APIURLMock {
    case coins
    case history

    var apiURL: APIURL {
        switch self {
        case .coins:
            return APIURL.coins(20, 0, .marketCap)
        case .history:
            return APIURL.history(Coin.bitcoin.uuid, .oneWeek)
        }
    }

    var responseCode: Int {
        return 200
    }

    var fileName: String? {
        return rawValue
    }
}

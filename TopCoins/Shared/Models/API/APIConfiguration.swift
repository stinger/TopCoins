//
//  APIConfiguration.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import Foundation

struct APIConfiguration {
    static let baseURL = "https://api.coinranking.com/v2"
    static let apiKey: String = {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "CoinrankingAPISecret") as? String {
            return apiKey
        } else {
            fatalError("Missing Coinranking API token! Refer to the README on how to obtain and set up one.")
        }
    }()
}

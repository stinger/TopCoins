//
//  URLSession+Mock.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import Foundation

extension URLSession {
    static let mock: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [
            URLProtocolMock<CoinbaseAPIURLMock>.self
        ]
        return URLSession(configuration: configuration)
    }()
}

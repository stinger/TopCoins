//
//  APIURL.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import Foundation

enum APIURL {
    typealias Limit = Int
    typealias Offset = Int

    case coins(Limit, Offset, CoinSorter)
    case history(String, Timespan)

    var path: String {
        switch self {
        case .coins:
            return "/coins"
        case .history(let uuid, _):
            return "/coin/\(uuid)/history"
        }
    }

    var httpMethod: String {
        "GET"
    }

    var needsAuthorization: Bool {
        true
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .coins(let limit, let offset, let sorter):
            [
                .init(name: "limit", value: "\(limit)"),
                .init(name: "offset", value: "\(offset)"),
                .init(name: "orderBy", value: sorter.rawValue),
            ]
        case .history(_, let period):
            [
                .init(name: "timePeriod", value: period.rawValue)
            ]
        }
    }

    var request: URLRequest? {
        guard let baseURL = URL(string: APIConfiguration.baseURL) else {
            return nil
        }
        var url = baseURL.appendingPathComponent(path)
        if let queryItems, var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems = queryItems
            url = components.url!
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        if needsAuthorization {
            request.addValue(APIConfiguration.apiKey, forHTTPHeaderField: "x-access-token")
        }
        return request
    }
}

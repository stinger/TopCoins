//
//  APIError.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unknown, unknownRequest
    case apiError(reason: String)
    case parserError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .unknownRequest:
            return "Unknown request"
        case .apiError(let reason), .parserError(let reason):
            return reason
        }
    }
}

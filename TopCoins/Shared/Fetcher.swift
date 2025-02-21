//
//  Fetcher.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import Foundation

func fetch(_ apiURL: APIURL, using urlSession: URLSession) async throws -> Data {
    guard let request = apiURL.request else {
        throw APIError.unknownRequest
    }
    do {
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
            throw APIError.unknown
        }
        return data
    } catch let error {
        if let error = error as? APIError {
            throw error
        } else {
            throw APIError.apiError(reason: error.localizedDescription)
        }
    }
}

func fetch<T: Decodable>(_ apiURL: APIURL, using urlSession: URLSession = .shared) async throws -> T {
    do {
        let data = try await fetch(apiURL, using: urlSession)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(T.self, from: data)
    } catch let error {
        if let error = error as? DecodingError {
            var errorToReport = error.localizedDescription
            switch error {
            case .dataCorrupted(let context):
                let details =
                    context.underlyingError?.localizedDescription
                    ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                errorToReport = "\(context.debugDescription) - (\(details))"
            case .keyNotFound(let key, let context):
                let details =
                    context.underlyingError?.localizedDescription
                    ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
            case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                let details =
                    context.underlyingError?.localizedDescription
                    ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
            @unknown default:
                break
            }
            throw APIError.parserError(reason: errorToReport)
        } else {
            throw APIError.apiError(reason: error.localizedDescription)
        }
    }
}

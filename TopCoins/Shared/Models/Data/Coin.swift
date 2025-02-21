//
//  Coin.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import Foundation

struct Coin: Codable, Identifiable, Hashable {
    var uuid: String
    var symbol: String
    var name: String
    var change: String
    var iconUrl: String
    var price: String
    var performance: String
    var color: String
    var listedAt: Date

    var priceDouble: Double {
        Double(price) ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case uuid
        case symbol
        case name
        case iconUrl
        case price
        case change
        case color
        case performance = "24hVolume"
        case listedAt
    }

    var id: String {
        uuid
    }

    var iconURL: URL? {
        guard let url = URL(string: iconUrl) else { return nil }

        if url.lastPathComponent.hasSuffix(".svg") {
            return url.deletingLastPathComponent()
                .appendingPathComponent(url.lastPathComponent.replacingOccurrences(of: ".svg", with: ".png"))
        }

        return url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

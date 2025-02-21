//
//  FavouritesViewModel.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Combine
import Foundation

final class FavouritesViewModel: ObservableObject {
    @Published var favourites: Set<Coin> = []

    private let storage: UserDefaults

    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }

    func loadFavourites() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        if let data = storage.data(forKey: UserDefaultsKeys.favourites.rawValue),
            let coins = try? decoder.decode(Set<Coin>.self, from: data)
        {
            favourites = coins
        }
    }

    func addToFavourite(coin: Coin) {
        favourites.insert(coin)

        saveFavourites()
    }

    func removeFromFavourite(coin: Coin) {
        if favourites.contains(coin) {
            favourites.remove(coin)
        }

        saveFavourites()
    }

    private func saveFavourites() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        if let data = try? encoder.encode(favourites) {
            storage.set(data, forKey: UserDefaultsKeys.favourites.rawValue)
        }
    }
}

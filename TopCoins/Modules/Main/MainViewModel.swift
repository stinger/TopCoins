//
//  MainViewModel.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import Combine
import Foundation
import OSLog

final class MainViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var sorter: CoinSorter = .marketCap
    @Published var searchTerm: String = ""

    private let pageSize = 20
    private let limit = 100
    private var totalCoins = 0
    private var nextPage = 0

    private var allCoins: [Coin] = []
    private var cancellables: Set<AnyCancellable> = []
    private let urlSession: URLSession
    private let isPagingEnabled: Bool

    var hasNextPage: Bool {
        isPagingEnabled && nextPage * pageSize < limit
    }

    init(urlSession: URLSession = .shared, isPagingEnabled: Bool = true) {
        self.urlSession = urlSession
        self.isPagingEnabled = isPagingEnabled

        $sorter
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.fetchCoins()
            }
            .store(in: &cancellables)

        $searchTerm
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] term in
                guard let self else { return }

                coins = allCoins.filter { entry in
                    guard !term.isEmpty else { return true }
                    return entry.name.lowercased().contains(term.lowercased())
                }
            }
            .store(in: &cancellables)
    }

    func fetchCoins(page: Int = 0) {
        if page == 0 {
            coins = []
            allCoins = []
        }
        Task {
            do {
                let response: APIResponse<CoinsData> = try await fetch(
                    APIURL.coins(pageSize, page * pageSize, sorter),
                    using: urlSession
                )
                totalCoins = response.data.stats.totalCoins
                nextPage = page == 0 ? 1 : page + 1
                allCoins.append(contentsOf: response.data.coins)

                coins = allCoins.filter { entry in
                    guard !searchTerm.isEmpty else { return true }
                    return entry.name.lowercased().contains(searchTerm.lowercased())
                }

            } catch let error {
                os_log(.error, "Error fetching coins: %@", error.localizedDescription)
            }
        }
    }

    func fetchNextPage() {
        guard hasNextPage else { return }
        fetchCoins(page: nextPage)
    }
}

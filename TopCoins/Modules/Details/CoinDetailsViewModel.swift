//
//  CoinDetailsViewModel.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Combine
import Foundation
import OSLog

class CoinDetailsViewModel: ObservableObject {
    @Published var history: [CoinHistoryEntry] = []
    @Published var period: Timespan = .oneWeek
    @Published var chartType: ChartType = .line
    @Published var coin: Coin

    private var cancellables: Set<AnyCancellable> = []
    private var urlSession: URLSession = .shared

    init(coin: Coin, urlSession: URLSession = .shared) {
        self.coin = coin
        self.urlSession = urlSession

        $period
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.fetchCoinHistory()
            }
            .store(in: &cancellables)
    }

    func fetchCoinHistory() {
        Task {
            do {
                let response: APIResponse<CoinHistoryData> = try await fetch(
                    APIURL.history(coin.uuid, period),
                    using: urlSession
                )

                await updateChart(with: response.data)
            } catch let error {
                os_log(.error, "Error loading coin history: %@", error.localizedDescription)
            }
        }
    }

    @MainActor
    private func updateChart(with data: CoinHistoryData) {
        history = data.history.filter { $0.price != nil }
    }
}

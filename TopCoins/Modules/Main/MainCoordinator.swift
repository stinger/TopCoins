//
//  MainCoordinator.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import UIKit

final class MainCoordinator: Coordinator {
    var addToFavourites: (Coin) -> Void = { _ in }

    private var urlSession: URLSession = .shared

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        let isPagingEnabled = urlSession != .mock

        let controller = MainViewController()
        controller.viewModel = MainViewModel(urlSession: urlSession, isPagingEnabled: isPagingEnabled)

        controller.tabBarItem = .init(
            title: "Top Coins",
            image: UIImage(systemName: "chart.bar.horizontal.page"),
            selectedImage: UIImage(systemName: "chart.bar.horizontal.page.fill")
        )

        let navigationController = AppNavigationController(rootViewController: controller)
        navigationController.navigationBar.prefersLargeTitles = true
        super.init(navigationController: navigationController, completion: nil)

        controller.displayDetails = { [weak self] coin in
            self?.showDetails(for: coin)
        }

        controller.addToFavourites = { [weak self] coin in
            self?.addToFavourites(coin)
        }
    }

    func showDetails(for coin: Coin) {
        let controller = CoinDetailsViewController()
        controller.viewModel = CoinDetailsViewModel(coin: coin, urlSession: urlSession)
        push(viewController: controller)
    }
}

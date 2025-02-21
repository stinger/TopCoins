//
//  FavouritesCoordinator.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import UIKit

final class FavouritesCoordinator: Coordinator {

    var addToFavourites: (Coin) -> Void = { _ in }

    private var userDefaults: UserDefaults = .standard
    private var urlSession: URLSession = .shared

    init(userDefaults: UserDefaults = .standard, urlSession: URLSession = .shared) {
        self.userDefaults = userDefaults
        self.urlSession = urlSession

        let controller = FavouritesViewController()
        controller.viewModel = FavouritesViewModel(storage: userDefaults)

        addToFavourites = { coin in
            controller.viewModel.addToFavourite(coin: coin)
        }

        controller.tabBarItem = .init(
            title: "Favourites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )

        let navigationController = AppNavigationController(rootViewController: controller)
        navigationController.navigationBar.prefersLargeTitles = true
        super.init(navigationController: navigationController, completion: nil)

        controller.displayDetails = { [weak self] coin in
            self?.showDetails(for: coin)
        }
    }

    func showDetails(for coin: Coin) {
        let controller = CoinDetailsViewController()
        controller.viewModel = CoinDetailsViewModel(coin: coin, urlSession: urlSession)
        push(viewController: controller)
    }
}

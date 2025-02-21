//
//  AppCoordinator.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Foundation

final class AppCoordinator: Coordinator {

    let mainCoordinator: MainCoordinator
    let favouritesCoordinator: FavouritesCoordinator

    let viewController: AppTabBarController

    init(
        controller: AppTabBarController,
        userDefaults: UserDefaults = .standard,
        urlSession: URLSession = .shared
    ) {
        viewController = controller
        mainCoordinator = MainCoordinator(urlSession: urlSession)
        favouritesCoordinator = FavouritesCoordinator(userDefaults: userDefaults, urlSession: urlSession)
        super.init(navigationController: nil, completion: nil)

        guard
            let mainNC = mainCoordinator.navigationController,
            let favouritesNC = favouritesCoordinator.navigationController
        else {
            return
        }

        controller.setViewControllers([mainNC, favouritesNC], animated: false)

        mainCoordinator.addToFavourites = { [weak self] coin in
            self?.favouritesCoordinator.addToFavourites(coin)
        }
    }
}

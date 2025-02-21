//
//  AppNavigationController.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import UIKit

final class AppNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
}

extension AppNavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if viewController == navigationController.viewControllers.first {
            navigationController.tabBarController?.setTabBarHidden(false, animated: false)
        } else {
            navigationController.tabBarController?.setTabBarHidden(true, animated: false)
        }
    }

}

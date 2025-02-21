//
//  AppPreview.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import SwiftUI

#Preview {
    let coordinator = AppCoordinator(
        controller: AppTabBarController(),
        userDefaults: .mock,
        urlSession: .mock
    )

    coordinator.viewController
}

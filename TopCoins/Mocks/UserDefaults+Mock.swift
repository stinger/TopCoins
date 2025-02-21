//
//  UserDefaults+Mock.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import Foundation

extension UserDefaults {
    static let mock: UserDefaults = {
        let name = Bundle.main.bundleIdentifier?.appending(".mock") ?? "TopCoins.UserDefaults.mock"
        let defaults = UserDefaults(suiteName: name)
        defaults?.removePersistentDomain(forName: name)
        return defaults ?? .init()
    }()
}

//
//  APIResponse.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let status: String
    let data: T
}

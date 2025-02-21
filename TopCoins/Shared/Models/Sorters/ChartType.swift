//
//  ChartType.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import Foundation

enum ChartType: CaseIterable, CustomStringConvertible {
    case area, dots, line

    var description: String {
        switch self {
        case .line:
            return "Line"
        case .area:
            return "Area"
        case .dots:
            return "Dots"
        }
    }

}

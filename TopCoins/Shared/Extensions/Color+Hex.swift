//
//  Color+Hex.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import Foundation
import OSLog
import SwiftUI

enum HexColorFormat {
    case argb, rgba
}

extension Color {
    init(hex: String, alpha: CGFloat = 1.0, format: HexColorFormat = .rgba) {
        // Normalize the hex string by removing any invalid characters.
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard !hex.isEmpty else {
            os_log(.error, "Invalid or empty hex string: %@", hex)
            self.init(.sRGB, red: 1.0, green: 0.0, blue: 0.0, opacity: alpha)  // Fallback to red color.
            return
        }

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)  // Safely parse the hex string.

        let cAlpha: Double
        let red: UInt64
        let green: UInt64
        let blue: UInt64

        switch (hex.count, format) {
        case (3, _):  // RGB (12-bit)
            (cAlpha, red, green, blue) = (
                alpha,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )
        case (6, _):  // RGB (24-bit)
            (cAlpha, red, green, blue) = (
                alpha,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        case (8, .rgba):  // RGBA (32-bit)
            (red, green, blue, cAlpha) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                Double(int & 0xFF) / 255
            )
        case (8, .argb):  // ARGB (32-bit)
            (cAlpha, red, green, blue) = (
                Double(int >> 24) / 255,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            os_log(.error, "Unsupported hex string length (%d) or format: %@", hex.count, "\(format)")
            (cAlpha, red, green, blue) = (alpha, 255, 0, 0)  // Fallback to red color.
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: cAlpha
        )
    }
}

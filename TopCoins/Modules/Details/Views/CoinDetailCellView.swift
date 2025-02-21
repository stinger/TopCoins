//
//  CoinDetailCellView.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import SwiftUI

struct CoinDetailCellView: View {
    var name: String
    var value: String

    var body: some View {
        GroupBox {
            VStack {
                Text(name)
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                Text(value)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    CoinDetailCellView(name: "One", value: "Two")
        .padding()
}

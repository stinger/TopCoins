//
//  CoinOverviewCell.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import SwiftUI
import UIKit

class CoinOverviewCell: UICollectionViewCell {
    var configuration: UIContentConfiguration?

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        contentConfiguration = configuration
    }
}

struct CoinOverviewView: View {
    var coin: Coin

    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: coin.iconURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "circle")
                    .resizable()
                    .scaledToFit()
            }
            .foregroundStyle(Color.secondary)
            .frame(maxWidth: 40, maxHeight: 40)
            .padding(.trailing, 16)

            Text(coin.name)
                .font(.body)

            Spacer()

            VStack(alignment: .trailing) {
                Text(coin.priceDouble, format: .currency(code: "USD"))

                Text(coin.change)
                    .foregroundStyle(coin.change.starts(with: "-") ? Color.red : Color.green)

            }
            .foregroundStyle(.secondary)
            .font(.footnote)

        }
        .padding(.horizontal)
    }
}

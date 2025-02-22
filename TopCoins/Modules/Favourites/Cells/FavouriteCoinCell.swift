//
//  CoinOverviewCell.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import SwiftUI
import UIKit

struct FavouriteCoinCellView: View {
    var coin: Coin

    var body: some View {
        HStack(alignment: .center) {
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
            .frame(maxWidth: 36, maxHeight: 36)
            .padding(.trailing, 8)

            Text(coin.name)
                .font(.body)
                .frame(maxHeight: .infinity, alignment: .center)

            Spacer()

            Text(coin.symbol)
                .foregroundStyle(.secondary)
                .font(.footnote)
        }
    }
}

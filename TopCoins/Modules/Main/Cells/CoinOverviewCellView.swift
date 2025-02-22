//
//  CoinOverviewCell.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import SwiftUI
import UIKit

struct CoinOverviewCellView: View {
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
            .frame(maxWidth: 36, maxHeight: 36)
            .padding(.trailing, 8)

            Text(coin.name)
                .font(.body)
                .frame(maxHeight: .infinity, alignment: .center)

            Spacer()

            VStack(alignment: .trailing) {
                Text(coin.change)
                    .bold()
                    .foregroundStyle(coin.change.starts(with: "-") ? Color.red : Color.green)

                Text(coin.priceDouble, format: .currency(code: "USD"))
            }
            .foregroundStyle(.secondary)
            .font(.footnote)

        }
    }
}

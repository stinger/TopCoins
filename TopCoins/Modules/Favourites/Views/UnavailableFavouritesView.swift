//
//  UnavailableFavoutitesView.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import SwiftUI

struct UnavailableFavouritesView: View {
    var body: some View {
        ContentUnavailableView("No favourites yet", systemImage: "xmark.circle")
    }
}

#Preview {
    UnavailableFavouritesView()
}

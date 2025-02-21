//
//  UnavailableDataView.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import SwiftUI

struct UnavailableDataView: View {
    var body: some View {
        ContentUnavailableView("No data available", systemImage: "xmark.circle")
    }
}

#Preview {
    UnavailableDataView()
}

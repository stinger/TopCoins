//
//  ChartHeaderView.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import SwiftUI
import UIKit

class ChartHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "PerformanceHistory"
    var viewModel: CoinDetailsViewModel!

    func setupChartView() {
        let controller = UIHostingController(
            rootView: CoinHistoryChartView(viewModel: self.viewModel)
        )
        guard let chartView = controller.view else {
            return
        }

        chartView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartView)

        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            chartView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

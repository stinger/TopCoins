//
//  CoinHistoryChartView.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Charts
import Foundation
import SwiftUI

struct CoinHistoryChartView: View {
    @StateObject var viewModel: CoinDetailsViewModel

    var body: some View {
        VStack {
            if !viewModel.history.isEmpty {
                Chart(viewModel.history, id: \.timestamp) { entry in
                    switch viewModel.chartType {
                    case .line:
                        LineMark(
                            x: .value("Time", entry.timestamp),
                            y: .value("Price", entry.priceDouble)
                        )
                    case .area:
                        AreaMark(
                            x: .value("Time", entry.timestamp),
                            y: .value("Price", entry.priceDouble)
                        )
                    case .dots:
                        PointMark(
                            x: .value("Time", entry.timestamp),
                            y: .value("Price", entry.priceDouble)
                        )
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .padding()
            } else {
                ContentUnavailableView("Loading data...", systemImage: "chart.line.uptrend.xyaxis")
            }

            Picker("Period", selection: $viewModel.period) {
                ForEach(Timespan.allCases, id: \.rawValue) { period in
                    Text(period.rawValue)
                        .tag(period)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    CoinHistoryChartView(viewModel: .init(coin: .bitcoin, urlSession: .mock))
}

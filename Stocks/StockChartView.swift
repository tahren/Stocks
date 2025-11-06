//
//  StockChartView.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 4/11/2025.
//

import SwiftUI
import Charts

struct StockChartView: View {
    var prices: [StockPrice]
    var body: some View {
        Chart(prices) { point in
            LineMark(
                x: .value("Date", point.timestamp),
                y: .value("Price", point.price)
            )
            .foregroundStyle(.blue)
            .interpolationMethod(.catmullRom)
            AreaMark(
                x: .value("Date", point.timestamp),
                y: .value("Price", point.price)
            )
            .foregroundStyle(LinearGradient(colors: [.blue.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom))
        }
        .chartYAxisLabel("Price")
        .chartXAxisLabel("Date")
    }
}

#Preview {
    StockChartView(prices: Stock.sample.prices)
}

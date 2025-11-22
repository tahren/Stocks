//
//  PortfolioChartView.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 22/11/2025.
//

import SwiftUI
import Charts
import SwiftData

struct PortfolioChartView: View {
    var holdings: [StockHolding]

    // Cumulative running total of shares over time
    private var cumulativeSeries: [(date: Date, totalShares: Decimal)] {
        let sorted = holdings.sorted { $0.date < $1.date }
        var runningTotal: Decimal = 0
        return sorted.map { holding in
            runningTotal += holding.numberOfShares
            return (date: holding.date, totalShares: runningTotal)
        }
    }

    var body: some View {
        Group {
            if holdings.isEmpty {
                ContentUnavailableView("No Holdings", systemImage: "chart.line.uptrend.xyaxis", description: Text("Add holdings to see your shares over time."))
            } else {
                Chart(cumulativeSeries, id: \.date) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Cumulative Shares", point.totalShares)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.monotone)

                    PointMark(
                        x: .value("Date", point.date),
                        y: .value("Cumulative Shares", point.totalShares)
                    )
                    .symbolSize(30)
                    .foregroundStyle(.blue.opacity(0.6))
                }
                .chartXAxisLabel("Date")
                .chartYAxisLabel("Cumulative Shares")
                .frame(minHeight: 240)
                .padding()
            }
        }
        .navigationTitle("Shares Over Time")
        .animation(.default, value: holdings)
    }
}

#Preview("With Sample Data") {
    PortfolioChartView(holdings: StockHolding.samples)
}

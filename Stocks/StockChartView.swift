//
//  StockChartView.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 4/11/2025.
//

import SwiftUI
import Charts

struct StockChartView: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedPrice: Double? = nil
    
    var prices: [StockPrice]
    var body: some View {
        Chart(prices) { point in
            LineMark(
                x: .value("Date", point.timestamp),
                y: .value("Price", point.price)
            )
            .foregroundStyle(.blue)
//            .interpolationMethod(.catmullRom)
            AreaMark(
                x: .value("Date", point.timestamp),
                y: .value("Price", point.price)
            )
            .foregroundStyle(LinearGradient(colors: [.blue.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom))
        }
        .chartYAxisLabel("Price")
        .chartXAxisLabel("Date")
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // Convert the x-location in the overlay to a Date on the chart's X axis
                            let origin = geo[proxy.plotAreaFrame].origin
                            let xPos = value.location.x - origin.x
                            if let date: Date = proxy.value(atX: xPos) {
                                selectedDate = date
                                // Find the nearest point's price for annotation
                                if let nearest = prices.min(by: { abs($0.timestamp.timeIntervalSince(date)) < abs($1.timestamp.timeIntervalSince(date)) }) {
                                    selectedPrice = nearest.price
                                }
                            }
                        }
                        .onEnded { _ in
                            selectedDate = nil
                            selectedPrice = nil
                        }
                    )
                    .overlay(alignment: .topLeading) {
                        if let date = selectedDate, let price = selectedPrice {
                            let xPosition = proxy.position(forX: date) ?? 0
                            let yPosition = proxy.position(forY: price) ?? 0

                            ZStack(alignment: .topLeading) {
                                // Vertical rule
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 1, height: geo.size.height)
                                    .offset(x: xPosition)

                                // Point marker at the nearest data point
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 8, height: 8)
                                    .offset(x: xPosition - 4, y: yPosition)

                                // Value bubble above the point
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(price, format: .number.precision(.fractionLength(2)))
                                    Text(date, format: .dateTime.year().month().day())
                                }
                                .font(.caption)
                                .padding(6)
                                .background(.white)
                                .foregroundStyle(.black)
                                .cornerRadius(6)
                                .shadow(radius: 2)
                                .offset(x: max(0, min(xPosition + 8, geo.size.width - 80)), y: max(0, yPosition - 36))
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    StockChartView(prices: Stock.sample.prices)
}

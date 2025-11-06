//
//  ContentView.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 2/11/2025.
//

import SwiftUI
import Foundation
import Charts
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Stock.name) private var stocks: [Stock]

    var stock: Stock {
        if let first = stocks.first { return first }
        // Create and insert a default AAPL stock if none exists
        let new = Stock(name: "AAPL", prices: [])
        modelContext.insert(new)
        return new
    }

    var body: some View {
        TabView {
            StockView(stock: stock)
                .tabItem {
                    Label("Prices", systemImage: "chart.xyaxis.line")
                }
            PortfolioView()
                .tabItem {
                    Label("Portfolio", systemImage: "book")
                }
        }
    }
}

#Preview {
    // Use a preview model container so @Query has a context
    ContentView()
        .modelContainer(for: Stock.self, inMemory: true)
}

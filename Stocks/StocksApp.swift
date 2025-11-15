//
//  StocksApp.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 2/11/2025.
//

import SwiftUI
import SwiftData

@main
struct StocksApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Stock.self, StockHolding.self])
    }
}

//
//  StockListView.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 4/11/2025.
//

import SwiftUI

struct StockListView: View {
    var prices: [StockPrice]
    var body: some View {
        List {
            ForEach(prices.sorted { $0.timestamp > $1.timestamp }) { price in
                HStack {
                    Text(price.timestamp, format: .dateTime.weekday().year().month().day())
                    Spacer()
                    Text(price.price, format: .currency(code: "USD"))
                }
            }
        }
    }
}

#Preview {
    StockListView(prices: Stock.sample.prices)
}

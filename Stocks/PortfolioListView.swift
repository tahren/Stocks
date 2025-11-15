//
//  PortfolioListView.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 16/11/2025.
//

import SwiftUI

struct PortfolioListView: View {
    var holding: StockHolding
    var body: some View {
        VStack {
            Text(dateString(from: holding.date))
//            Text("\(holding.type)")
        }
    }
}

#Preview {
    PortfolioListView(holding: StockHolding(transactionDate: Date(), type: .espp, purchasePrice: 23.36, numberOfShares: 30))
}

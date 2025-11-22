//
//  PortfolioListView.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 16/11/2025.
//

import SwiftUI

struct PortfolioEntryView: View {
    var holding: StockHolding
    var body: some View {
        VStack {
            HStack {
                Text(dateString(from: holding.date))
                Spacer()
                Image(systemName: portfolioImage(holding: holding))
                    .foregroundStyle(portfolioTintColor(holding: holding))
                Spacer()
                Text(String(describing: holding.type))
            }
            HStack {
                Text(holding.purchasePrice, format: .currency(code: "USD"))
                Spacer()
                Text("\(holding.numberOfShares, format: .number) shares")
                Spacer()
                Text(holding.cost, format: .currency(code: "USD"))

            }
        }
        .font(.caption2)
        .padding(.horizontal)
    }
}

#Preview {
    PortfolioEntryView(holding: StockHolding(transactionDate: Date(), type: .espp, purchasePrice: 24, numberOfShares: 30))
}

func portfolioImage(holding: StockHolding) -> String {
    switch holding.type {
    case .espp:
        return "dollarsign.square"
    case .rsu:
        return "list.dash.header.rectangle"
    default:
        return "dollarsign.arrow.trianglehead.counterclockwise.rotate.90"
    }
}

func portfolioTintColor(holding: StockHolding) -> Color {
    switch holding.type {
    case .espp:
        return .green
    case .rsu:
        return .blue
    default:
        return .gray
    }
}

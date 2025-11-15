//
//  PortfolioView.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 4/11/2025.
//

import SwiftUI
import SwiftData

struct PortfolioView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor<StockHolding>(\.date, order: .reverse)]) private var holdings: [StockHolding]

    var body: some View {
        NavigationStack {
            Group {
                if holdings.isEmpty {
                    ContentUnavailableView("No Holdings", systemImage: "tray", description: Text("Add some template holdings to get started."))
                } else {
                    List {
                        ForEach(holdings) { holding in
                            Text("\(dateString(from: holding.date, includeWeekday: true))")
                        }
                        .onDelete(perform: deleteHoldings)
                    }
                }
            }
            Spacer()
            Text("Number of holdings: \(holdings.count)")
            .navigationTitle("Portfolio")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Templates") { addTemplateHoldingsV2(using: modelContext) }
                }
                ToolbarItem(placement: .secondaryAction) {
                    Button(role: .destructive) {
                        deleteAllHoldings()
                    } label: {
                        Label("Delete All", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    private func deleteHoldings(at offsets: IndexSet) {
        for index in offsets {
            let holding = holdings[index]
            modelContext.delete(holding)
        }
        try? modelContext.save()
    }

    private func deleteAllHoldings() {
        for holding in holdings {
            modelContext.delete(holding)
        }
        try? modelContext.save()
    }
}

#Preview {
    PortfolioView()
        .modelContainer(for: StockHolding.self, inMemory: true)
}

func addTemplateHoldingsV2(using context: ModelContext) {
    let samples: [StockHolding] = [
        StockHolding(transactionDate: Date(), type: .rsu, rsuPack: 1, purchasePrice: Decimal(string: "145.32")!, numberOfShares: Decimal(string: "10")!),
        StockHolding(transactionDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, type: .espp, rsuPack: 0, purchasePrice: Decimal(string: "120.00")!, numberOfShares: Decimal(string: "5.5")!),
        StockHolding(transactionDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!, type: .dividends, rsuPack: 0, purchasePrice: Decimal(string: "0.00")!, numberOfShares: Decimal(string: "1.25")!)
    ]
    for sample in samples {
        context.insert(sample)
    }
    try? context.save()
}

let myHoldings = ["31 Jan 2016", "ESPP", "$20.68", "60"]

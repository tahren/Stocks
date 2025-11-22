//
//  PortfolioListView.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 22/11/2025.
//

import SwiftUI
import SwiftData

struct PortfolioListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor<StockHolding>(\.date, order: .reverse)]) private var holdings: [StockHolding]

    var body: some View {
        VStack {
            Group {
                if holdings.isEmpty {
                    ContentUnavailableView("No Holdings", systemImage: "tray", description: Text("Add some template holdings to get started."))
                } else {
                    List {
                        ForEach(holdings) { holding in
                            PortfolioEntryView(holding: holding)
                        }
                        .onDelete(perform: deleteHoldings)
                    }
                }
            }
            Spacer()
            Text("Number of entries: \(holdings.count)")
            HStack {
                Button(role: .destructive) {
                    deleteAllHoldings()
                } label: {
                    Label("Delete All", systemImage: "trash")
                }
                .disabled(holdings.isEmpty)
                Spacer()
                Button("Add Templates") { addTemplateHoldingsV2(using: modelContext) }
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.bordered)
        }
        .padding()
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
    PortfolioListView()
        .modelContainer(for: StockHolding.self, inMemory: true)
}

import SwiftUI
import SwiftData

struct StockView: View {
    @Environment(\.modelContext) private var modelContext
    let stock: Stock
    @State private var isLoading = false
    @State private var showDeleteConfirm = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            let prices = stock.prices.sorted { $0.timestamp < $1.timestamp }
            if !prices.isEmpty {
                StockChartView(prices: prices)
            } else {
                Text("No price data available")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack {
                Text("Total records: \(stock.prices.count)")
                Spacer()
                UpdateRecordsButton(isLoading: $isLoading, isUpToDate: !stock.prices.isEmpty, isDisabled: !stock.prices.isEmpty, action: {
                    print("Updating records now")
                    do {
                        try await updateStockPriceRecordsV2(API: APIendpoint, stock: stock)
                    } catch {
                        print("Request failed with error: \(error)")
                    }
                })
                Spacer().frame(width: 8)
                Button(role: .destructive) {
                    showDeleteConfirm = true
                } label: {
                    Text("Delete")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .disabled(isLoading)
                .confirmationDialog("Delete \(stock.name)?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                    Button("Delete", role: .destructive) {
                        modelContext.delete(stock)
                        try? modelContext.save()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("This will remove the saved stock and its prices.")
                }
            }
        }
        .padding()
    }
}

#Preview {
    // Preview with in-memory model container
    StockView(stock: Stock(name: "AAPL", prices: Stock.sample.prices))
        .modelContainer(for: Stock.self, inMemory: true)
}

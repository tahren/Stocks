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
                TabView {
                    StockChartView(prices: prices)
                    StockListView(prices: prices)
                }
                .tabViewStyle(.page)
            } else {
                Text("No price data available")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("Total records: \(stock.prices.count)")
            HStack {
                Button {
                    if updateIsRequired(today: Date(), lastUpdateDate: prices.last?.timestamp) {
                        print("Update is required")
                        generateAPIURL(from: prices.last?.timestamp, to: Date())
                    } else {
                        print("No update required")
                    }
                } label: {
                    Text("Check")
                }
                Spacer()
                Button {
                    Task { @MainActor in
                        isLoading = true
                        defer { isLoading = false }
                        do {
                            try await updateStockPriceRecordsV3(stock: stock, from: prices.last?.timestamp, to: Date())
                        } catch {
                            print("Request failed: \(error)")
                        }
                    }
                } label: {
                    Text(updateButtonText(isLoading: isLoading, updateRequired: updateIsRequired(today: Date(), lastUpdateDate: prices.last?.timestamp)))
                }
                .disabled(isLoading || !updateIsRequired(today: Date(), lastUpdateDate: prices.last?.timestamp))
                Spacer()
                Button(role: .destructive) {
                    showDeleteConfirm = true
                } label: {
                    Text("Delete")
                }
                .disabled(prices.isEmpty)
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
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
        .padding()
    }
}

#Preview {
    // Preview with in-memory model container
    StockView(stock: Stock(name: "AAPL", prices: Stock.sample.prices))
        .modelContainer(for: Stock.self, inMemory: true)
}

func updateButtonText(isLoading: Bool, updateRequired: Bool) -> String {
    if isLoading {
        return "Updating..."
    }
    if !updateRequired {
        return "Up to date"
    }
    return "Update records"
}

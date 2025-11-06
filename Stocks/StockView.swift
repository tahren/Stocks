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
                    } else {
                        print("No update required")
                    }
                } label: {
                    Text("Check")
                }
                Spacer()
                UpdateRecordsButton(isLoading: $isLoading, isUpToDate: !stock.prices.isEmpty, isDisabled: !stock.prices.isEmpty, action: {
                    print("Updating records now")
                    do {
                        try await updateStockPriceRecordsV2(baseAPI: baseAPIendpoint, stock: stock)
                    } catch {
                        print("Request failed with error: \(error)")
                    }
                })
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

func lastWeekday(date: Date) -> Date {
    let tempComponents = Calendar.current.dateComponents([.weekday], from: date)
    if tempComponents.weekday! == 7 {
        return date.addingTimeInterval(-86400)
    }
    if tempComponents.weekday! == 1 {
        return date.addingTimeInterval(-172800)
    }
    return date
}

func updateIsRequired(today: Date, lastUpdateDate: Date?) -> Bool {
//    let todayFormatted = today.formatted(.dateTime.weekday().year().month().day())
    var tempDay = today

    for i in 0...6 {
        tempDay.addTimeInterval(86400)
        let tempComponents = Calendar.current.dateComponents([.weekday], from: tempDay)
        print("i:", i, tempDay, "Weekday:", tempComponents.weekday!, "Last weekday:", lastWeekday(date: tempDay).formatted(.dateTime.year().month().day().weekday()))
    }
    
    let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: today)
    print("Today: \(todayComponents.year!)-\(todayComponents.month!)-\(todayComponents.day!)")

    if let lastUpdateDate {
        // Format last timestamp in a readable way
        let lastComponents = Calendar.current.dateComponents([.year, .month, .day], from: lastUpdateDate)
        print("Last record date: \(lastComponents.year!)-\(lastComponents.month!)-\(lastComponents.day!)")
    }
    return false
}

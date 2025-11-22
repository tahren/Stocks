import Foundation
import SwiftData

/// The type of a stock holding.
public enum StockHoldingType: String, Codable, CaseIterable, Sendable {
    case rsu = "RSU"
    case espp = "ESPP"
    case dividends = "Dividends"
}

/// A model representing a stock holding.
@Model
public final class StockHolding: Identifiable {
    public var id: UUID
    public var date: Date
    public var type: StockHoldingType
    public var rsuPack: Int?
    public var purchasePrice: Decimal
    public var numberOfShares: Decimal
    public var cost: Decimal {
        return numberOfShares * purchasePrice
    }
    
    public init(
        id: UUID = UUID(),
        transactionDate: Date,
        type: StockHoldingType,
        rsuPack: Int? = nil,
        purchasePrice: Decimal,
        numberOfShares: Decimal
    ) {
        self.id = id
        self.date = transactionDate
        self.type = type
        self.rsuPack = rsuPack
        self.purchasePrice = purchasePrice
        self.numberOfShares = numberOfShares
    }
}


// MARK: - Samples for previews/tests
public extension StockHolding {
    static var samples: [StockHolding] {
        let calendar = Calendar.current
        let base = Date()
        func daysAgo(_ d: Int) -> Date { calendar.date(byAdding: .day, value: -d, to: base) ?? base }

        return [
            StockHolding(transactionDate: daysAgo(120), type: .rsu, rsuPack: 1, purchasePrice: 120.50, numberOfShares: 5),
            StockHolding(transactionDate: daysAgo(90), type: .espp, purchasePrice: 101.03, numberOfShares: 3.5),
            StockHolding(transactionDate: daysAgo(60), type: .rsu, rsuPack: 2, purchasePrice: 130.10, numberOfShares: 7),
            StockHolding(transactionDate: daysAgo(45), type: .dividends, purchasePrice: 0, numberOfShares: 0.25),
            StockHolding(transactionDate: daysAgo(30), type: .espp, purchasePrice: 98.75, numberOfShares: 4),
            StockHolding(transactionDate: daysAgo(15), type: .rsu, rsuPack: 3, purchasePrice: 140.20, numberOfShares: 6.75),
            StockHolding(transactionDate: daysAgo(0), type: .espp, purchasePrice: 105.90, numberOfShares: 5.2)
        ]
    }
}

// Convenience single sample
public extension StockHolding {
    static var sample: StockHolding { samples.last! }
}

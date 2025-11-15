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


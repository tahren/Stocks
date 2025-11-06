//
//  StockModels.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 2/11/2025.
//

import Foundation

/// A single price point for a stock at a specific time.
public struct StockPrice: Identifiable, Codable, Hashable, Sendable {
    /// Unique identifier for this price point.
    public let id: UUID
    /// The time at which the price was recorded.
    public let timestamp: Date
    /// The price value.
    public let price: Double

    /// Creates a new stock price point.
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID).
    ///   - timestamp: The time at which the price was recorded.
    ///   - price: The price value.
    public init(id: UUID = UUID(), timestamp: Date, price: Double) {
        self.id = id
        self.timestamp = timestamp
        self.price = price
    }
}

/// A stock with a name and a collection of price points over time.
public struct Stock: Identifiable, Codable, Hashable, Sendable {
    /// Unique identifier for this stock.
    public let id: UUID
    /// The display name or ticker symbol of the stock.
    public var name: String
    /// The historical or intraday price points for the stock.
    public var prices: [StockPrice]

    /// Creates a new stock model.
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID).
    ///   - name: The stock name or ticker symbol.
    ///   - prices: Array of price points for the stock.
    public init(id: UUID = UUID(), name: String, prices: [StockPrice]) {
        self.id = id
        self.name = name
        self.prices = prices
    }
}

public extension Stock {
    /// A sample stock with a few recent price points for previews and testing.
    static let sample: Stock = {
        let now = Date()
        let prices: [StockPrice] = [
            StockPrice(timestamp: now.addingTimeInterval(-3600 * 3), price: 148.32),
            StockPrice(timestamp: now.addingTimeInterval(-3600 * 2), price: 149.10),
            StockPrice(timestamp: now.addingTimeInterval(-3600 * 1), price: 150.24),
            StockPrice(timestamp: now, price: 149.85)
        ]
        return Stock(name: "AAPL", prices: prices)
    }()
}

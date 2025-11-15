//
//  StockModels.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 2/11/2025.
//

import Foundation
import SwiftData

/// A single price point for a stock at a specific time.
@Model
public final class StockPrice: Identifiable {
    public var id: UUID
    public var timestamp: Date
    public var price: Double

    public init(id: UUID = UUID(), timestamp: Date, price: Double) {
        self.id = id
        self.timestamp = timestamp
        self.price = price
    }
}

/// A stock with a name and a collection of price points over time.
@Model
public final class Stock: Identifiable {
    public var id: UUID
    public var name: String
    public var prices: [StockPrice]

    public init(id: UUID = UUID(), name: String, prices: [StockPrice] = []) {
        self.id = id
        self.name = name
        self.prices = prices
    }
}

public extension Stock {
    static let sample: Stock = {
        let calendar = Calendar.current
        let tz = TimeZone.current
        var comps = DateComponents()
        comps.timeZone = tz
        comps.year = 2025
        comps.month = 11

        comps.day = 5
        let nov5 = calendar.date(from: comps) ?? Date()
        comps.day = 6
        let nov6 = calendar.date(from: comps) ?? Date()
        comps.day = 7
        let nov7 = calendar.date(from: comps) ?? Date()

        let prices: [StockPrice] = [
            StockPrice(timestamp: nov5, price: 148.32),
            StockPrice(timestamp: nov6, price: 169.10),
            StockPrice(timestamp: nov7, price: 150.24)
        ]
        return Stock(name: "AAPL", prices: prices)
    }()
}

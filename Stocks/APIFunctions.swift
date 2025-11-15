//
//  APIFunctions.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 4/11/2025.
//

import Foundation

let baseAPIendpoint = "https://financialmodelingprep.com/stable/historical-price-eod/light?symbol=AAPL"

func generateAPIURL(from: Date?, to: Date) -> String {
    let toDate = "&to=\(dateString(from: lastWeekday(date: to)))"
    var fromDate = "&from=2015-01-01"
    if let from {
        fromDate = "&from=\(dateString(from: nextWeekday(date: from)))"
    }
    let APIFooter = "&apikey=wkfYcAeWbl5QjiFf2TJUD8Rh1vFQnbgo"
    let API = baseAPIendpoint + fromDate + toDate + APIFooter
    print("Generated API URL: \(API):")
    return API
}

@MainActor
func updateStockPriceRecordsV3(stock: Stock, from: Date?, to: Date) async throws {
    if let from {
        print("Last record date: \(dateString(from: from, includeWeekday: true))")
    }
    let API = generateAPIURL(from: from, to: to)
    print("Attempting to get API responses from \(API):")
    print("Current stock prices: \(stock.prices.count)")
    
    guard let url = URL(string: API) else {
        print("Invalid URL: \(API)")
        return
    }

    struct PriceItem: Decodable {
        let symbol: String
        let date: String
        let price: Double
        // Other fields (like volume) are ignored
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    if let httpResponse = response as? HTTPURLResponse {
        print("HTTP Status: \(httpResponse.statusCode)")
    }

    // New API returns an array of objects with date in format "YYYY-MM-DD"
    let decoded = try JSONDecoder().decode([PriceItem].self, from: data)

    // Date formatter for the new date format
    let df = DateFormatter()
    df.calendar = Calendar(identifier: .gregorian)
    df.locale = Locale(identifier: "en_US_POSIX")
    df.timeZone = TimeZone(secondsFromGMT: 0)
    df.dateFormat = "yyyy-MM-dd"

    for item in decoded {
        guard let parsedDate = df.date(from: item.date) else { continue }
        let price = StockPrice(timestamp: parsedDate, price: item.price)
        // Avoid duplicates: if a price with same day already exists, skip
        if !stock.prices.contains(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: parsedDate) }) {
            stock.prices.append(price)
        }
    }

    print("Total stock prices now: \(stock.prices.count)")
    // Sort prices by timestamp ascending for charting
    stock.prices.sort { $0.timestamp < $1.timestamp }
    print("Sorted prices by date")
}

@MainActor
func updateStockPriceRecordsV2(baseAPI: String, stock: Stock) async throws {
    let today = Date()
    let components = Calendar.current.dateComponents([.year, .month, .day], from: today)
    print("\(components.year!)-\(components.month!)-\(components.day!)")
    let fromDate = "&from=2015-01-01"
    let toDate = "&to=2024-11-04"
    let APIFooter = "&apikey=wkfYcAeWbl5QjiFf2TJUD8Rh1vFQnbgo"
    let API = baseAPI + fromDate + toDate + APIFooter
    print("Attempting to get API responses from \(API):")

    guard let url = URL(string: API) else {
        print("Invalid URL: \(API)")
        return
    }

    struct PriceItem: Decodable {
        let symbol: String
        let date: String
        let price: Double
        // Other fields (like volume) are ignored
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    if let httpResponse = response as? HTTPURLResponse {
        print("HTTP Status: \(httpResponse.statusCode)")
    }

    // New API returns an array of objects with date in format "YYYY-MM-DD"
    let decoded = try JSONDecoder().decode([PriceItem].self, from: data)

    // Date formatter for the new date format
    let df = DateFormatter()
    df.calendar = Calendar(identifier: .gregorian)
    df.locale = Locale(identifier: "en_US_POSIX")
    df.timeZone = TimeZone(secondsFromGMT: 0)
    df.dateFormat = "yyyy-MM-dd"

    for item in decoded {
        guard let parsedDate = df.date(from: item.date) else { continue }
        let price = StockPrice(timestamp: parsedDate, price: item.price)
        // Avoid duplicates: if a price with same day already exists, skip
        if !stock.prices.contains(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: parsedDate) }) {
            stock.prices.append(price)
        }
    }

    // Sort prices by timestamp ascending for charting
    stock.prices.sort { $0.timestamp < $1.timestamp }
}

// uses the old API endpoint that only gets 249 price records per request
@MainActor
func updateStockPriceRecords(stock: Stock) async throws {
    let baseAPI = "https://api.marketstack.com/v1/eod?access_key="
    let APIkey = "4447e9c9bff332f7328e10d9de1a08bf"
    let APIfooter = "&symbols=AAPL"
    let API = baseAPI + APIkey + APIfooter
    print("Attempting to get API responses from \(API):")

    guard let url = URL(string: API) else {
        print("Invalid URL: \(API)")
        return
    }

    struct EODResponse: Decodable {
        struct EODItem: Decodable {
            let date: String
            let close: Double
        }
        let data: [EODItem]
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    if let httpResponse = response as? HTTPURLResponse {
        print("HTTP Status: \(httpResponse.statusCode)")
    }

    // Decode using ISO8601 with fractional seconds which MarketStack uses (e.g., 2025-02-11T00:00:00+0000)
//    let decoder = JSONDecoder()
    let iso = ISO8601DateFormatter()
    iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withColonSeparatorInTimeZone]

    let decoded = try JSONDecoder().decode(EODResponse.self, from: data)

    for item in decoded.data {
        // Parse date string
        var parsedDate: Date
        if let d = iso.date(from: item.date) {
            parsedDate = d
        } else if let d = ISO8601DateFormatter().date(from: item.date) {
            parsedDate = d
        } else {
            continue
        }
        let price = StockPrice(timestamp: parsedDate, price: item.close)
        // Avoid duplicates: if a price with same day already exists, skip
        if !stock.prices.contains(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: parsedDate) }) {
            stock.prices.append(price)
        }
    }

    // Sort prices by timestamp ascending for charting
    stock.prices.sort { $0.timestamp < $1.timestamp }
}

func updateIsRequired(today: Date, lastUpdateDate: Date?) -> Bool {
    print("Checking if update is required")
    
    if let lastUpdateDate {
        print("Last update date: \(dateString(from: lastUpdateDate, includeWeekday: true))")
    } else {
        print("No records yet")
        return true
    }

    print("Today: \(dateString(from: today, includeWeekday: true))")
    
    print("Next update date: \(dateString(from: nextWeekday(date: lastUpdateDate!), includeWeekday: true))")
    let lastWeekdayFromToday = lastWeekday(date: today)
    print("Last weekday: \(dateString(from: lastWeekdayFromToday, includeWeekday: true))")

    if lastUpdateDate! > lastWeekdayFromToday {
        print("Next update date is after today, so no update is needed")
        return false
    }
    
    if !Calendar.current.isDate(lastWeekdayFromToday, inSameDayAs: lastUpdateDate!) {
        print("Last updated date is not today, so an update is needed")
        return true
    }
    print("Last updated date is today, so no update is needed")
    return false
}

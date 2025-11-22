//
//  DateFunctions.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 12/11/2025.
//

import Foundation

func lastWeekday(date: Date) -> Date {
    let calendar = Calendar.current
    // If it's already a weekday, return as-is
    if !calendar.isDateInWeekend(date) {
        return date
    }
    // Step back by calendar days until we hit a weekday (handles DST correctly)
    var cursor = date
    while calendar.isDateInWeekend(cursor) {
        guard let previousDay = calendar.date(byAdding: .day, value: -1, to: cursor) else {
            break
        }
        cursor = previousDay
    }
    return cursor
}

func nextWeekday(date: Date) -> Date {
    let calendar = Calendar.current
    // If it's already a weekday, return as-is
    // Step forward by calendar days until we hit a weekday (handles DST correctly)
    var cursor = date
    repeat {
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: cursor) else {
            break
        }
        cursor = nextDay
    } while calendar.isDateInWeekend(cursor)
    return cursor
}

func dateString(from date: Date, includeWeekday: Bool = false) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    if includeWeekday {
        formatter.dateFormat = "yyy-MM-dd-EEEE"
    } else {
        formatter.dateFormat = "yyyy-MM-dd"
    }
    return formatter.string(from: date)
}

func getWeekday(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.setLocalizedDateFormatFromTemplate("EEEE")
    return formatter.string(from: date)
}

/// Parses dates like "31 Jan 2016" into Date using a stable POSIX formatter.
func parseHoldingDate(_ string: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "dd MMM yyyy"
    return formatter.date(from: string)!
}

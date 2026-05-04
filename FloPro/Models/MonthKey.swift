//
//  MonthKey.swift
//  FloPro
//
//  Created by Anirudh Sharma on 29/04/26.
//
import Foundation

struct MonthKey: Hashable, Codable {
    let year: Int
    let month: Int

    init(from date: Date, calendar: Calendar = .current) {
        let components = calendar.dateComponents([.year, .month], from: date)
        self.year = components.year!
        self.month = components.month!
    }

    var stringValue: String {
        String(format: "%04d-%02d", year, month)
    }
}

struct DayKey: Hashable, Codable {
    let year: Int
    let month: Int
    let day: Int

    init(from date: Date, calendar: Calendar = .current) {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        self.year = components.year!
        self.month = components.month!
        self.day = components.day!
    }

    var stringValue: String {
        String(format: "%04d-%02d-%02d", year, month, day)
    }
}

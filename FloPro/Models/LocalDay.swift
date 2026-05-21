//
//  LocalDay.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//
import Foundation

struct LocalDay: Hashable, Codable, Comparable {
    let year: Int
    let month: Int
    let day: Int

    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    static func < (lhs: LocalDay, rhs: LocalDay) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }

        if lhs.month != rhs.month {
            return lhs.month < rhs.month
        }

        return lhs.day < rhs.day
    }

    func date(in calendar: Calendar = .current) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return calendar.date(from: components)
    }

    func addingDays(_ value: Int, calendar: Calendar = .current) -> LocalDay? {
        guard
            let date = date(in: calendar),
            let updatedDate = calendar.date(byAdding: .day, value: value, to: date)
        else {
            return nil
        }

        return LocalDay(date: updatedDate, calendar: calendar)
    }

    init(date: Date, calendar: Calendar = .current) {
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }
}

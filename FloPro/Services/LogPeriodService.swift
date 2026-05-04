//
//  LogPeriodService.swift
//  FloPro
//
//  Created by Anirudh Sharma on 29/04/26.
//

import Foundation

struct LogPeriodService {
    private let storageKey = "logged_period_dates"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func logPeriod(for date: Date, in month: String) {
        var loggedDates = fetchLoggedPeriods(for: month)
        loggedDates.insert(dayKey(for: date))
        persist(loggedDates, for: month)
    }

    func isPeriodLogged(for date: Date, in month: String) -> Bool {
        fetchLoggedPeriods(for: month).contains(dayKey(for: date))
    }

    func fetchLoggedPeriods(for month: String) -> Set<String> {
        allLoggedPeriods()[month] ?? []
    }

    private func persist(_ loggedDates: Set<String>, for month: String) {
        var monthDict = allLoggedPeriods()
        monthDict[month] = loggedDates

        guard let encodedDates = try? JSONEncoder().encode(monthDict) else {
            return
        }

        userDefaults.set(encodedDates, forKey: storageKey)
    }

    private func allLoggedPeriods() -> [String: Set<String>] {
        guard let data = userDefaults.data(forKey: storageKey) else {
            return [:]
        }

        if let dates = try? JSONDecoder().decode([String: Set<String>].self, from: data) {
            return dates
        }

        if let legacyDates = try? JSONDecoder().decode([String: Set<Date>].self, from: data) {
            return legacyDates.mapValues { dates in
                Set(dates.map(dayKey(for:)))
            }
        }

        return [:]
    }

    private func dayKey(for date: Date) -> String {
        DayKey(from: date).stringValue
    }
}

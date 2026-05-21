//
//  LogPeriodService.swift
//  FloPro
//
//  Created by Anirudh Sharma on 29/04/26.
//

import Foundation

struct LogPeriodService {
    private let storageKey = "logged_day_records"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func logDay(_ dayRecord: DayRecord) {
        persist(dayRecord)
    }
    
    func fetchDay(_ day: LocalDay) -> DayRecord? {
        let loggedDays = allLoggedDays()
        return loggedDays.first { $0.day == day}
    }

    private func persist(_ dayRecord: DayRecord) {
        var loggedDays = allLoggedDays()
        loggedDays = loggedDays.filter { $0.day != dayRecord.day }
        loggedDays.insert(dayRecord)

        guard let encodedDays = try? JSONEncoder().encode(loggedDays) else {
            return
        }

        userDefaults.set(encodedDays, forKey: storageKey)
    }

    func allLoggedDays() -> Set<DayRecord> {
        guard let data = userDefaults.data(forKey: storageKey),
              let allLoggedDays = try? JSONDecoder().decode(Set<DayRecord>.self, from: data) else {
            return []
        }

        return allLoggedDays
    }
    
    
}

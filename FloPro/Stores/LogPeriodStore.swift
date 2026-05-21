//
//  PeriodStore.swift
//  FloPro
//
//  Created by Anirudh Sharma on 21/05/26.
//

import Observation

@Observable
final class LogPeriodStore {
    private let logPeriodService = LogPeriodService()

    private(set) var loggedDays: [LocalDay: DayRecord] = [:]

    init() {
        refresh()
    }

    func logPeriod(for day: LocalDay) {
        let current = loggedDays[day]
        let updatedRecord = DayRecord(
            day: day,
            isPeriod: !(current?.isPeriod ?? false),
            periodFlow: current?.periodFlow,
            symptoms: current?.symptoms,
            mood: current?.mood,
            symptomIntensity: current?.symptomIntensity
        )

        loggedDays[day] = updatedRecord
        logPeriodService.logDay(updatedRecord)
    }

    func refresh() {
        loggedDays = Dictionary(
            uniqueKeysWithValues: logPeriodService.allLoggedDays().map { ($0.day, $0) }
        )
    }
}

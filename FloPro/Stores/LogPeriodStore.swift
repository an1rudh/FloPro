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

    var loggedRecords: [DayRecord] {
        loggedDays.values.sorted { $0.day < $1.day }
    }

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
        )

        save(updatedRecord)
    }

    func logSymptoms(
        symptoms: Set<Symptom>?,
        mood: Mood?,
        day: LocalDay
    ) {
        let currentRecord = loggedDays[day]
        let updatedRecord = DayRecord(
            day: day,
            isPeriod: currentRecord?.isPeriod ?? false,
            periodFlow: currentRecord?.periodFlow,
            symptoms: symptoms ?? currentRecord?.symptoms ?? [],
            mood: mood,
        )

        save(updatedRecord)
    }

    func record(for day: LocalDay) -> DayRecord? {
        loggedDays[day]
    }

    func refresh() {
        loggedDays = Dictionary(
            uniqueKeysWithValues: logPeriodService.allLoggedDays().map { ($0.day, $0) }
        )
    }

    private func save(_ dayRecord: DayRecord) {
        loggedDays[dayRecord.day] = dayRecord
        logPeriodService.logDay(dayRecord)
    }
}

//
//  CyclePredictionService.swift
//  FloPro
//
//  Created by Codex on 06/05/26.
//

import Foundation

struct CyclePrediction {
    let predictedPeriodDays: Set<LocalDay>
    let fertileWindowDays: Set<LocalDay>
    let ovulationDays: Set<LocalDay>

    static let empty = CyclePrediction(
        predictedPeriodDays: [],
        fertileWindowDays: [],
        ovulationDays: []
    )
}

struct CycleInsightSummary {
    struct ChartEntry: Identifiable {
        let startDay: LocalDay
        let cycleLength: Int

        var id: LocalDay { startDay }
    }

    let averageCycleLength: Int
    let averagePeriodLength: Int
    let currentCycleDay: Int?
    let nextPredictedPeriodStart: LocalDay?
    private let periodStarts: [LocalDay]
    private let calendar: Calendar

    init(
        averageCycleLength: Int,
        averagePeriodLength: Int,
        currentCycleDay: Int?,
        nextPredictedPeriodStart: LocalDay?,
        periodStarts: [LocalDay],
        calendar: Calendar
    ) {
        self.averageCycleLength = averageCycleLength
        self.averagePeriodLength = averagePeriodLength
        self.currentCycleDay = currentCycleDay
        self.nextPredictedPeriodStart = nextPredictedPeriodStart
        self.periodStarts = periodStarts
        self.calendar = calendar
    }

    var chartEntries: [ChartEntry] {
        Array(
            Array(zip(periodStarts, periodStarts.dropFirst()))
                .compactMap { start, nextStart in
                    guard
                        let startDate = start.date(in: calendar),
                        let nextDate = nextStart.date(in: calendar),
                        let interval = calendar.dateComponents([.day], from: startDate, to: nextDate).day
                    else {
                        return nil
                    }

                    return ChartEntry(
                        startDay: nextStart,
                        cycleLength: max(interval, 1)
                    )
                }
                .suffix(12)
        )
    }

    static func empty(
        fallbackCycleLength: Int,
        fallbackPeriodLength: Int,
        calendar: Calendar
    ) -> CycleInsightSummary {
        CycleInsightSummary(
            averageCycleLength: max(fallbackCycleLength, 1),
            averagePeriodLength: max(fallbackPeriodLength, 1),
            currentCycleDay: nil,
            nextPredictedPeriodStart: nil,
            periodStarts: [],
            calendar: calendar
        )
    }
}

struct CyclePredictionService {
    private let calendar: Calendar
    
    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func prediction(
        from records: [DayRecord],
        defaultCycleLength: Int,
        defaultPeriodLength: Int,
        futureCyclesToPredict: Int = 2
    ) -> CyclePrediction {
        let loggedPeriodDays = records
            .filter(\.isPeriod)
            .map(\.day)
            .sorted()

        let starts = periodStarts(from: loggedPeriodDays)
        guard let lastPeriodStart = starts.last else {
            return .empty
        }

        let streaks = periodStreaks(from: loggedPeriodDays)
        let cycleLength = inferredCycleLength(from: starts, fallback: defaultCycleLength)
        let periodLength = inferredPeriodLength(from: streaks, fallback: defaultPeriodLength)

        var predictedPeriodDays: Set<LocalDay> = []
        var fertileWindowDays: Set<LocalDay> = []
        var ovulationDays: Set<LocalDay> = []

        for cycleOffset in 1...futureCyclesToPredict {
            guard
                let predictedStart = lastPeriodStart.addingDays(
                    cycleLength * cycleOffset,
                    calendar: calendar
                )
            else {
                continue
            }

            for dayOffset in 0..<periodLength {
                guard let day = predictedStart.addingDays(dayOffset, calendar: calendar) else {
                    continue
                }
                predictedPeriodDays.insert(day)
            }

            guard let ovulationDay = predictedStart.addingDays(-14, calendar: calendar) else {
                continue
            }

            ovulationDays.insert(ovulationDay)

            for fertileOffset in -5...0 {
                guard let fertileDay = ovulationDay.addingDays(fertileOffset, calendar: calendar) else {
                    continue
                }
                fertileWindowDays.insert(fertileDay)
            }
        }

        return CyclePrediction(
            predictedPeriodDays: predictedPeriodDays,
            fertileWindowDays: fertileWindowDays,
            ovulationDays: ovulationDays
        )
    }

    func insightSummary(
        from records: [DayRecord],
        defaultCycleLength: Int,
        defaultPeriodLength: Int,
        referenceDate: Date = Date()
    ) -> CycleInsightSummary {
        let loggedPeriodDays = records
            .filter(\.isPeriod)
            .map(\.day)
            .sorted()

        let starts = periodStarts(from: loggedPeriodDays)
        let streaks = periodStreaks(from: loggedPeriodDays)
        let averageCycleLength = inferredCycleLength(
            from: starts,
            fallback: defaultCycleLength
        )
        let averagePeriodLength = inferredPeriodLength(
            from: streaks,
            fallback: defaultPeriodLength
        )

        guard let lastPeriodStart = starts.last else {
            return .empty(
                fallbackCycleLength: averageCycleLength,
                fallbackPeriodLength: averagePeriodLength,
                calendar: calendar
            )
        }

        let currentCycleDay = currentCycleDay(
            since: lastPeriodStart,
            referenceDate: referenceDate
        )
        let nextPredictedPeriodStart = lastPeriodStart.addingDays(
            averageCycleLength,
            calendar: calendar
        )
        return CycleInsightSummary(
            averageCycleLength: averageCycleLength,
            averagePeriodLength: averagePeriodLength,
            currentCycleDay: currentCycleDay,
            nextPredictedPeriodStart: nextPredictedPeriodStart,
            periodStarts: starts,
            calendar: calendar
        )
    }

    private func periodStarts(from loggedPeriodDays: [LocalDay]) -> [LocalDay] {
        periodStreaks(from: loggedPeriodDays).compactMap(\.first)
    }

    private func periodStreaks(from loggedPeriodDays: [LocalDay]) -> [[LocalDay]] {
        guard let firstDay = loggedPeriodDays.first else {
            return []
        }

        var streaks: [[LocalDay]] = [[firstDay]]

        for day in loggedPeriodDays.dropFirst() {
            guard let previousDay = streaks[streaks.count - 1].last else {
                continue
            }

            if previousDay.addingDays(1, calendar: calendar) == day {
                streaks[streaks.count - 1].append(day)
            } else {
                streaks.append([day])
            }
        }

        return streaks
    }

    private func inferredCycleLength(from starts: [LocalDay], fallback: Int) -> Int {
        var intervals: [Int] = []

        for (start, nextStart) in zip(starts, starts.dropFirst()) {
            guard
                let startDate = start.date(in: calendar),
                let nextDate = nextStart.date(in: calendar)
            else {
                continue
            }

            guard let interval = calendar.dateComponents([.day], from: startDate, to: nextDate).day else {
                continue
            }

            intervals.append(interval)
        }

        guard !intervals.isEmpty else {
            return max(fallback, 1)
        }

        return max(intervals.reduce(0, +) / intervals.count, 1)
    }

    private func inferredPeriodLength(from streaks: [[LocalDay]], fallback: Int) -> Int {
        guard !streaks.isEmpty else {
            return max(fallback, 1)
        }

        return max(streaks.reduce(0) { $0 + $1.count } / streaks.count, 1)
    }

    private func currentCycleDay(
        since lastPeriodStart: LocalDay,
        referenceDate: Date
    ) -> Int? {
        guard let startDate = lastPeriodStart.date(in: calendar) else {
            return nil
        }

        let normalizedReferenceDate = calendar.startOfDay(for: referenceDate)
        guard
            let elapsedDays = calendar.dateComponents(
                [.day],
                from: startDate,
                to: normalizedReferenceDate
            ).day
        else {
            return nil
        }

        return max(elapsedDays + 1, 1)
    }

    
    func nextPeriodInDays(
        from records: [DayRecord],
        defaultCycleLength: Int,
        referenceDate: Date = Date()
    ) -> Int {
        let loggedPeriodDays = records
            .filter(\.isPeriod)
            .map(\.day)
            .sorted()

        let starts = periodStarts(from: loggedPeriodDays)
        guard let lastPeriodStart = starts.last else {
            return 0
        }

        let cycleLength = inferredCycleLength(
            from: starts,
            fallback: defaultCycleLength
        )
        let today = calendar.startOfDay(for: referenceDate)

        guard var nextPeriodStart = lastPeriodStart.addingDays(
            cycleLength,
            calendar: calendar
        ) else {
            return 0
        }

        while let nextPeriodStartDate = nextPeriodStart.date(in: calendar),
              nextPeriodStartDate < today {
            guard let advancedStart = nextPeriodStart.addingDays(
                cycleLength,
                calendar: calendar
            ) else {
                return 0
            }

            nextPeriodStart = advancedStart
        }

        guard let nextPeriodStartDate = nextPeriodStart.date(in: calendar),
              let daysUntilNextPeriod = calendar.dateComponents(
                [.day],
                from: today,
                to: nextPeriodStartDate
              ).day
        else {
            return 0
        }

        return max(daysUntilNextPeriod, 0)
    }
}

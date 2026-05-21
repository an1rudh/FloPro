//
//  FloProTests.swift
//  FloProTests
//
//  Created by Anirudh Sharma on 27/04/26.
//

import Foundation
import Testing
@testable import FloPro

struct FloProTests {

    @Test func cyclePredictionUsesLoggedStartsAndLengths() throws {
        let service = CyclePredictionService(calendar: Calendar(identifier: .gregorian))
        let records = [
            DayRecord(day: LocalDay(year: 2026, month: 5, day: 1), isPeriod: true),
            DayRecord(day: LocalDay(year: 2026, month: 5, day: 2), isPeriod: true),
            DayRecord(day: LocalDay(year: 2026, month: 5, day: 29), isPeriod: true),
            DayRecord(day: LocalDay(year: 2026, month: 5, day: 30), isPeriod: true)
        ]

        let prediction = service.prediction(
            from: records,
            defaultCycleLength: 30,
            defaultPeriodLength: 5,
            futureCyclesToPredict: 1
        )

        #expect(prediction.predictedPeriodDays.contains(LocalDay(year: 2026, month: 6, day: 26)))
        #expect(prediction.predictedPeriodDays.contains(LocalDay(year: 2026, month: 6, day: 27)))
        #expect(!prediction.predictedPeriodDays.contains(LocalDay(year: 2026, month: 6, day: 28)))
        #expect(prediction.ovulationDays.contains(LocalDay(year: 2026, month: 6, day: 12)))
        #expect(prediction.fertileWindowDays.contains(LocalDay(year: 2026, month: 6, day: 7)))
        #expect(prediction.fertileWindowDays.contains(LocalDay(year: 2026, month: 6, day: 12)))
    }

    @Test func cyclePredictionFallsBackToDefaultLengths() throws {
        let service = CyclePredictionService(calendar: Calendar(identifier: .gregorian))
        let records = [
            DayRecord(day: LocalDay(year: 2026, month: 5, day: 1), isPeriod: true),
            DayRecord(day: LocalDay(year: 2026, month: 5, day: 2), isPeriod: true),
            DayRecord(day: LocalDay(year: 2026, month: 5, day: 3), isPeriod: true)
        ]

        let prediction = service.prediction(
            from: records,
            defaultCycleLength: 28,
            defaultPeriodLength: 5,
            futureCyclesToPredict: 1
        )

        #expect(prediction.predictedPeriodDays.contains(LocalDay(year: 2026, month: 5, day: 29)))
        #expect(prediction.predictedPeriodDays.contains(LocalDay(year: 2026, month: 6, day: 2)))
        #expect(prediction.ovulationDays.contains(LocalDay(year: 2026, month: 5, day: 15)))
    }

}

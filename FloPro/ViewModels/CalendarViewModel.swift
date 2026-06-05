//
//  CalendarViewModel.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import Foundation
import Combine
import SwiftUI

@Observable
class CalendarViewModel {
    private(set) var loggedDays: [LocalDay: DayRecord] = [:]
    private(set) var cyclePrediction: CyclePrediction = .empty
    private let cyclePredictionService: CyclePredictionService
    private let calendar: Calendar

    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekDays = ["M", "T", "W", "T", "F", "S", "S"]
    let today: LocalDay
    var monthArray: [Date] = []
    var monthOffsets: [Int] = []
    var currentMonth: Date
    var isPrepending = false
    
    var isLegendCollapsed = false
    private var initialOffset: CGFloat?

    init(
        cyclePredictionService: CyclePredictionService = CyclePredictionService()
    ) {
        self.calendar = .current
        self.cyclePredictionService = cyclePredictionService
        let now = Date()
        let components = calendar.dateComponents([.year, .month], from: now)
        self.currentMonth = calendar.date(from: components)!
        self.today = LocalDay(
            year: calendar.component(.year, from: Date()),
            month: calendar.component(.month, from: Date()),
            day: calendar.component(.day, from: Date())
        )
    }
    
    func handleScroll(_ offset: CGFloat) {
        if initialOffset == nil {
            initialOffset = offset
        }

        guard let initialOffset else { return }

        let scrollDistance = initialOffset - offset

        withAnimation(.spring(duration: 0.3)) {
            isLegendCollapsed = scrollDistance > 50
        }
    }
    
    func generateMonths() {
        monthArray = (-10...10).map { offset in
            getMonths(by: offset)
        }
        monthOffsets = (-10...10).map { offset in
            offset
        }
    }
    
    func onScroll(to month: Date) {
        guard let index = monthArray.firstIndex(of: month) else { return }
        if index < 3 && !isPrepending {
            prependMonths()
        } else if index >= monthArray.count - 3 {
            appendMonths()
        }
    }
    
    func reduceCalendarInMemory(fromEnd: Bool) {
        if monthArray.count > 50 {
            if fromEnd {
                monthArray = Array(monthArray[monthArray.count - 50...monthArray.count - 1])
            } else {
                monthArray = Array(monthArray[0...50])
            }
        }
    }
    
    func appendMonths() {
        let lastOffset = monthOffsets.last!
        for i in 1...5 {
            monthOffsets.append(lastOffset + i)
            monthArray.append(getMonths(by: lastOffset + i))
        }
        reduceCalendarInMemory(fromEnd: false)
    }
    
    func prependMonths() {
        isPrepending = true
        let firstOffset = monthOffsets.first!
        for i in 1...5 {
            monthOffsets.insert(firstOffset - i, at: 0)
            monthArray.insert(getMonths(by: firstOffset - i), at: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isPrepending = false
        }
        reduceCalendarInMemory(fromEnd: true)
    }

    func changeMonth(by value: Int) {
        currentMonth = calendar.date(
            byAdding: .month,
            value: value,
            to: currentMonth
        )!
    }
    
    func getMonths(by value: Int) -> Date {
        calendar.date(
            byAdding: .month,
            value: value,
            to: currentMonth
        )!
    }

    func calendarDayCells(for month: Date?) -> [LocalDay?] {
        let monthComponents = calendar.dateComponents(
            [.year, .month],
            from: month ?? currentMonth
        )
        guard
            let firstDayOfMonth = calendar.date(from: monthComponents),
            let dayRange = calendar.range(
                of: .day,
                in: .month,
                for: firstDayOfMonth
            )
        else {
            return []
        }

        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        let leadingEmptyDays = (weekday + 5) % 7

        var cells: [LocalDay?] = Array(
            repeating: nil,
            count: leadingEmptyDays
        )

        for day in dayRange {
            var components = monthComponents
            components.day = day

            guard let date = calendar.date(from: components) else { continue }

            let localDay = LocalDay(
                year: calendar.component(.year, from: date),
                month: calendar.component(.month, from: date),
                day: calendar.component(.day, from: date)
            )

            cells.append(
                localDay
            )
        }

        return cells
    }

    func isPeriodLogged(for day: LocalDay) -> Bool {
        loggedDays[day]?.isPeriod ?? false
    }

    func getBackgroundColor(for day: LocalDay) -> Color {
        if isPeriodLogged(for: day) {
            return CalendarItems.LegendItemTitle.period.color
        }
        if isPredictedPeriod(for: day) {
            return CalendarItems.LegendItemTitle.period.color.opacity(0.35)
        }
        if isInFertileWindow(for: day) {
            return CalendarItems.LegendItemTitle.fertileWindow.color
        }
        return AppColors.cardBackground
    }

    func isToday(_ day: LocalDay) -> Bool {
        return day == today
    }

    func setLoggedDays(
        _ loggedDays: [LocalDay: DayRecord],
        userData: UserData?
    ) {
        self.loggedDays = loggedDays
        refreshPrediction(userData: userData)
    }

    func isPredictedPeriod(for day: LocalDay) -> Bool {
        cyclePrediction.predictedPeriodDays.contains(day)
    }

    func isInFertileWindow(for day: LocalDay) -> Bool {
        cyclePrediction.fertileWindowDays.contains(day)
    }

    func showOvulationIndicator(for day: LocalDay) -> Bool {
        cyclePrediction.ovulationDays.contains(day)
    }

    private func refreshPrediction(userData: UserData?) {
        let defaultCycleLength = userData?.cylceLength ?? 28
        let defaultPeriodLength = userData?.periodLength ?? 5

        cyclePrediction = cyclePredictionService.prediction(
            from: Array(loggedDays.values),
            defaultCycleLength: defaultCycleLength,
            defaultPeriodLength: defaultPeriodLength
        )
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .infinity

    static func reduce(
        value: inout CGFloat,
        nextValue: () -> CGFloat
    ) {
        value = min(value, nextValue())
    }
}

//
//  CalendarViewModel.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import Foundation
import SwiftUI
import Combine


class CalendarViewModel: ObservableObject {
    @Published var currentMonth = Date()
    @Published private(set) var loggedPeriodDates: Set<String>
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekDays = ["M", "T", "W", "T", "F", "S", "S"]
    private let logPeriodService: LogPeriodService
    
    init(logPeriodService: LogPeriodService = LogPeriodService()) {
        let currentMonth = Date()
        self.currentMonth = currentMonth
        self.logPeriodService = logPeriodService
        self.loggedPeriodDates = logPeriodService.fetchLoggedPeriods(for: MonthKey(from: currentMonth).stringValue)
    }

    func daysInMonth() -> Dictionary<Int, Date> {
        let calendar = Calendar.current
        let monthComponents = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth) else {
            return [:]
        }

        var daysByNumber: [Int: Date] = [:]

        for day in range {
            var components = monthComponents
            components.day = day

            if let date = calendar.date(from: components) {
                let normalized = Calendar.current.startOfDay(for: date)
                daysByNumber[day] = normalized
            }
        }
        return daysByNumber
    }
    
    func getMonthArray() -> [(Int, Date?)] {
        let offset = firstWeekdayOffset()
        let days = daysInMonth().sorted( by: { $0.key < $1.key } )
        return Array(repeating: (0, nil), count: offset) + days
    }
    
    func firstWeekdayOffset() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        let firstDay = calendar.date(from: components)!
        let weekday = calendar.component(.weekday, from: firstDay)
        return (weekday + 5) % 7
    }

    func monthYearString(from date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date ?? currentMonth)
    }

    func changeMonth(by value: Int) {
        self.currentMonth = Calendar.current.date(
            byAdding: .month,
            value: value,
            to: currentMonth
        )!
        self.loggedPeriodDates = logPeriodService.fetchLoggedPeriods(for: monthKey(for: currentMonth))
    }

    func isToday(day: Int) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let currentComponents = calendar.dateComponents([.year, .month], from: currentMonth)
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        return currentComponents.year == todayComponents.year &&
               currentComponents.month == todayComponents.month &&
               todayComponents.day == day
    }
    
    func getBackgroundColor(date: Date) -> Color {
        if isPeriodLogged(for: date) {
            return .blue.opacity(0.2)
        } else {
            return .clear
        }
    }
    
    func isPeriodLogged(for date: Date) -> Bool {
        loggedPeriodDates.contains(dayKey(for: date))
    }
    
    func logPeriod(for date: Date) {
        let dayKey = dayKey(for: date)
        let currentMonthKey = monthKey(for: currentMonth)
        if loggedPeriodDates.contains(dayKey) {
            loggedPeriodDates.remove(dayKey)
        } else {
            logPeriodService.logPeriod(for: date, in: currentMonthKey)
            loggedPeriodDates.insert(dayKey)
        }
    }

    private func monthKey(for date: Date) -> String {
        MonthKey(from: date).stringValue
    }

    private func dayKey(for date: Date) -> String {
        DayKey(from: date).stringValue
    }
}

//
//  CalendarDayCell.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//
import Foundation

struct CalendarDayCell: Hashable {
    let date: Date
    let day: LocalDay
    let dayNumber: Int
    let isInCurrentMonth: Bool
    
    init(date: Date, day: LocalDay, dayNumber: Int = 0, isInCurrentMonth: Bool) {
        self.date = date
        self.day = day
        self.dayNumber = dayNumber
        self.isInCurrentMonth = isInCurrentMonth
    }
}

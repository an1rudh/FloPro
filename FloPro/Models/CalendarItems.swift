//
//  CalendarItem.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//

import Foundation

enum LegendTitle: String, CaseIterable {
    case today = "today"
    case ovulation = "ovulation"
    case fertileWindow = "fertileWindow"
    case period = "period"
    var title: String {
        switch self {
        case .fertileWindow: return "Fertile Window"
        case .today: return "Today"
        case .ovulation: return "Ovulation"
        case .period: return "Period"
        }
    }
}

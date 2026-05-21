//
//  CalendarItem.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//

import Foundation
import SwiftUI

@Observable
final class CalendarItems {
    enum LegendItemTitle: String, CaseIterable {
        case today = "today"
        case fertileWindow = "fertileWindow"
        case ovulation = "ovulation"
        case period = "period"
        var title: String {
            switch self {
                case .fertileWindow: return "Fertile Window"
                case .today: return "Today"
                case .ovulation: return "Ovulation"
                case .period: return "Period"
            }
        }
        var color: Color {
            switch self {
            case .today: return .clear
                case .ovulation: return Color(hex: 0xF7B238)
                case .fertileWindow: return Color(hex: 0xD9E6FF)
                case .period: return Color(hex: 0xF7A8C8)
            }
        }
        var symbolColor: Color? {
            switch self {
            case .ovulation: return Color(hex: 0xF7B238)
                case .today: return nil
                case .fertileWindow: return nil
                case .period: return nil
            }
        }
        var symbol: String? {
            switch self {
                case .ovulation: return "sparkle"
                case .today: return nil
                case .fertileWindow: return nil
                case .period: return nil
            }
        }
    }
}

//
//  InsightsModel.swift
//  FloPro
//
//  Created by Anirudh Sharma on 22/05/26.
//

import Foundation
import SwiftUI

struct InsightRow: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let tint: Color
}

enum InsightSection: CaseIterable {
    case overview
    case symptoms
    case mood
    case sleep

    var title: String {
        switch self {
        case .overview:
            return "Overview"
        case .symptoms:
            return "Symptoms"
        case .mood:
            return "Mood"
        case .sleep:
            return "Sleep"
        }
    }
}

struct InsightArticle: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
}

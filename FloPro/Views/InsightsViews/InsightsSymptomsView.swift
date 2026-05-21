//
//  InsightsSymptomsView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//

import SwiftUI

struct InsightsSymptomsView: View {
    let loggedRecords: [DayRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            InsightsListCardView(
                title: "Top symptoms",
                subtitle: "Based on your logged cycle history.",
                rows: topSymptoms.map { symptom, count in
                    InsightRow(
                        title: symptomTitle(symptom),
                        detail: "\(count) logs",
                        tint: Color(hex: 0xF2A4B8)
                    )
                },
                emptyMessage:
                    "Log symptoms in the calendar to see patterns here."
            )

            //            articleSection(items: symptomArticles)
        }
    }

    var topSymptoms: [(Symptom, Int)] {
        Dictionary(
            loggedRecords
                .compactMap(\.symptoms)
                .flatMap(Array.init)
                .map { ($0, 1) },
            uniquingKeysWith: +
        )
        .sorted { lhs, rhs in
            if lhs.value == rhs.value {
                return lhs.key.rawValue < rhs.key.rawValue
            }

            return lhs.value > rhs.value
        }
        .prefix(4)
        .map { ($0.key, $0.value) }
    }

    private func symptomTitle(_ symptom: Symptom) -> String {
        switch symptom {
        case .cramps:
            return "Cramps"
        case .headache:
            return "Headache"
        case .bloating:
            return "Bloating"
        case .acne:
            return "Acne"
        case .fatigue:
            return "Fatigue"
        case .backache:
            return "Backache"
        }
    }
}

#Preview {
    InsightsSymptomsView(loggedRecords: [])
}

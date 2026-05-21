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
                        title: symptom.title,
                        detail: "\(count) logs",
                        tint: Color(hex: 0xF2A4B8)
                    )
                },
                emptyMessage:
                    "Log symptoms in the calendar to see patterns here."
            )

                ArticleCardView(items: symptomArticles)
        }
    }
    
    private var symptomArticles: [InsightArticle] {
        [
            InsightArticle(
                title: "Managing cramps",
                subtitle: "Relief ideas for tough days",
                icon: "waveform.path.ecg",
                gradient: LinearGradient(
                    colors: [Color(hex: 0xFFB2B2), Color(hex: 0xFF7A8A)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            InsightArticle(
                title: "Bloating and cycle changes",
                subtitle: "Why symptoms shift over time",
                icon: "drop.fill",
                gradient: LinearGradient(
                    colors: [Color(hex: 0xFFC38E), Color(hex: 0xF28A76)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        ]
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

}

#Preview {
    InsightsSymptomsView(loggedRecords: [])
}

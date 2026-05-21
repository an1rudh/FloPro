//
//  InsightsMoodView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 22/05/26.
//

import SwiftUI

struct InsightsMoodView: View {
    let loggedRecords: [DayRecord]
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            InsightsListCardView(
                title: "Mood patterns",
                subtitle: "A quick view of your most common moods.",
                rows: topMoods.map { mood, count in
                    InsightRow(
                        title: mood.title,
                        detail: "\(count) logs",
                        tint: mood.tint
                    )
                },
                emptyMessage:
                    "Start logging mood entries to build your mood trends."
            )
            
            ArticleCardView(items: moodArticles)
        }
    }
    
    private var moodArticles: [InsightArticle] {
        [
            InsightArticle(
                title: "Mood swings decoded",
                subtitle: "Spot hormone-driven patterns",
                icon: "brain.head.profile",
                gradient: LinearGradient(
                    colors: [Color(hex: 0x8A7CFF), Color(hex: 0xC694FF)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            InsightArticle(
                title: "Calming your luteal phase",
                subtitle: "Small habits that help",
                icon: "leaf.fill",
                gradient: LinearGradient(
                    colors: [Color(hex: 0x77C6A5), Color(hex: 0x55A0B9)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
        ]
    }
    
    private var topMoods: [(Mood, Int)] {
        Dictionary(
            loggedRecords
                .compactMap(\.mood)
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
    InsightsMoodView(loggedRecords: [])
}

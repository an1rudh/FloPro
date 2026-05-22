//
//  InsightsOverviewView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 22/05/26.
//

import SwiftUI

struct InsightsOverviewView: View {
    @Environment(UserStore.self) private var userStore
    
    private let cyclePredictionService: CyclePredictionService
    private let calendar: Calendar
    let loggedRecords: [DayRecord]
    
    init(
        cyclePredictionService: CyclePredictionService =
        CyclePredictionService(),
        calendar: Calendar = .current,
        loggedRecords: [DayRecord]
    ) {
        self.cyclePredictionService = cyclePredictionService
        self.calendar = calendar
        self.loggedRecords = loggedRecords
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            overviewCard
            ArticleCardView(items: overviewArticles)
        }
    }
    
    private var overviewArticles: [InsightArticle] {
        [
            InsightArticle(
                title: "What is PMS?",
                subtitle: "Understand your body better",
                icon: "heart.fill",
                gradient: LinearGradient(
                    colors: [Color(hex: 0xFFAAC5), Color(hex: 0xF06E9B)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            InsightArticle(
                title: "How to improve sleep",
                subtitle: "Tips for better rest",
                icon: "moon.zzz.fill",
                gradient: LinearGradient(
                    colors: [Color(hex: 0x17395B), Color(hex: 0x3A7AB8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
        ]
    }
    
    private var overviewCard: some View {
        let summary = insightSummary
        
        return CardView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cycle overview")
                        .font(.system(size: 24, weight: .bold))
                    
                    Text(calendarLabel)
                        .font(.system(size: 16, weight: .medium))
                }
                
                HStack(spacing: 0) {
                    statColumn(
                        value: "\(summary.averageCycleLength)",
                        title: "Avg cycle length"
                    )
                    
                    Divider()
                        .frame(height: 64)
                        .padding(.horizontal, 18)
                    
                    statColumn(
                        value: "\(summary.averagePeriodLength)",
                        title: "Avg period length"
                    )
                }
                
                CycleHistoryChartView(
                    entries: summary.chartEntries,
                    fallbackValue: summary.averageCycleLength,
                    calendar: calendar
                )
                
                if let currentCycleDay = summary.currentCycleDay {
                    HStack {
                        Text("Day \(currentCycleDay) of your cycle")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .semibold,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(Color(hex: 0x3A3D58))
                        Spacer()
                        if let nextPeriodStart = summary
                            .nextPredictedPeriodStart
                        {
                            Text(
                                "Next period \(formatted(day: nextPeriodStart))"
                            )
                            .font(
                                .system(
                                    size: 14,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(Color(hex: 0x8B7AAE))
                        }
                    }
                }
            }
            .padding(22)
        }
    }
    
    private var insightSummary: CycleInsightSummary {
        cyclePredictionService.insightSummary(
            from: loggedRecords,
            defaultCycleLength: userStore.userData?.cylceLength ?? 28,
            defaultPeriodLength: userStore.userData?.periodLength ?? 5,
            referenceDate: Date()
        )
    }
    
    
    
    private var calendarLabel: String {
        Date().formatted(.dateTime.month(.abbreviated).year())
    }
    
    private func formatted(day: LocalDay) -> String {
        guard let date = day.date(in: calendar) else {
            return "--"
        }
        
        return date.formatted(.dateTime.month(.abbreviated).day())
    }
    
    private func statColumn(value: String, title: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.system(size: 46, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: 0x202342))
            
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: 0x70738A))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

#Preview {
    InsightsOverviewView(loggedRecords: [])
        .environment(UserStore())
}

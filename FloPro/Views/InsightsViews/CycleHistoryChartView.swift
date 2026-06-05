//
//  CycleHistoryChart.swift
//  FloPro
//
//  Created by Anirudh Sharma on 22/05/26.
//

import SwiftUI

struct CycleHistoryChartView: View {
    let entries: [CycleInsightSummary.ChartEntry]
    let fallbackValue: Int
    let calendar: Calendar
    var body: some View {
        if entries.isEmpty {
            Spacer()
            Text("Start logging your period to see insights about your cycle")
                .font(AppTypographies.body)
                .foregroundStyle(AppColors.primaryText)
        } else {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .bottom) {
                    ForEach(
                        Array(displayEntries.enumerated()),
                        id: \.element.id
                    ) { index, entry in
                        VStack {
                            UnevenRoundedRectangle(
                                topLeadingRadius: 5,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 5,
                                style: .continuous
                            )
                            .fill(AppColors.tertiaryGradient)
                            .overlay(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.22),
                                        .clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                            .frame(
                                width: 18,
                                height: max(
                                    CGFloat(
                                        Double(entry.cycleLength) / maxValue
                                    ) * 120,
                                    22
                                )
                            )
                            
                            Text(label(for: entry.startDay))
                                .font(AppTypographies.button)
                                .foregroundStyle(AppColors.secondaryText)
                        }
                        .frame(alignment: .bottom)
                    }
                    Spacer()
                }
                .frame(height: 150, alignment: .center)
                
                if entries.isEmpty {
                    Text(
                        "Log at least two periods to unlock cycle trend history."
                    )
                    .font(AppTypographies.button)
                    .foregroundStyle(AppColors.primaryText)
                }
            }
            
        }
        
        
    }
    private func label(for day: LocalDay) -> String {
        guard let date = day.date(in: calendar) else {
            return "--"
        }
        
        return date.formatted(.dateTime.month(.narrow))
    }
    
    private var displayEntries: [CycleInsightSummary.ChartEntry] {
        if entries.isEmpty {
            return []
        }
        return entries
    }
    
    private var maxValue: Double {
        Double(max(displayEntries.map(\.cycleLength).max() ?? fallbackValue, 1))
    }
}

#Preview {
    let calendar = Calendar.current
    let summary = CycleInsightSummary.empty(
        fallbackCycleLength: 28,
        fallbackPeriodLength: 5,
        calendar: calendar
    )

    CycleHistoryChartView(
        entries: summary.chartEntries,
        fallbackValue: summary.averageCycleLength,
        calendar: calendar
    )
}

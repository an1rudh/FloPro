//
//  InsightsView.swift
//  FloPro
//
//  Created by Codex on 06/05/26.
//

import SwiftUI

struct InsightsView: View {
    @Environment(UserStore.self) private var userStore
    @State private var selectedSection: InsightSection = .overview

    private let logPeriodService: LogPeriodService
    private let cyclePredictionService: CyclePredictionService
    private let calendar: Calendar

    init(
        logPeriodService: LogPeriodService = LogPeriodService(),
        cyclePredictionService: CyclePredictionService = CyclePredictionService(),
        calendar: Calendar = .current
    ) {
        self.logPeriodService = logPeriodService
        self.cyclePredictionService = cyclePredictionService
        self.calendar = calendar
    }

    var body: some View {
        ZStack {
            BackdropView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    sectionPicker
                    switch selectedSection {
                    case .overview:
                        overviewContent
                    case .symptoms:
                        InsightsSymptomsView(loggedRecords: loggedRecords)
                    case .mood:
                        moodContent
                    case .sleep:
                        InsightsSleepView()
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
    }
    
    func insightListCard(
        title: String,
        subtitle: String,
        rows: [InsightRow],
        emptyMessage: String
    ) -> some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: 0x202342))

                    Text(subtitle)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(hex: 0x70738A))
                }

                if rows.isEmpty {
                    Text(emptyMessage)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(hex: 0x8B8FA7))
                } else {
                    ForEach(rows) { row in
                        HStack(spacing: 14) {
                            Circle()
                                .fill(row.tint.opacity(0.2))
                                .frame(width: 42, height: 42)
                                .overlay {
                                    Circle()
                                        .fill(row.tint)
                                        .frame(width: 18, height: 18)
                                }

                            Text(row.title)
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color(hex: 0x202342))

                            Spacer()

                            Text(row.detail)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundStyle(Color(hex: 0x8B8FA7))
                        }
                    }
                }
            }
            .padding(22)
        }
    }

    private var header: some View {
        HStack {
            Spacer()
            Text("Insights")
                .font(.system(size: 28, weight: .bold))
            Spacer()
        }
        .padding(.top, 4)
    }

    private var sectionPicker: some View {
        HStack() {
            Spacer()
            ForEach(InsightSection.allCases, id: \.self) { section in
                Button {
                    selectedSection = section
                } label: {
                    Text(section.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(
                            selectedSection == section
                                ? Color(hex: 0x8F71D9)
                                : Color(hex: 0x70738A)
                        )
                        .lineLimit(1)
                        .frame(height: 38)
                        .padding(.horizontal, 10)
                        .background(
                            Capsule(style: .continuous)
                                .fill(
                                    selectedSection == section
                                        ? Color(hex: 0xEEE7FF)
                                        : Color.white.opacity(0.72)
                                )
                        )
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
    }

    private var overviewContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            overviewCard
            articleSection(items: overviewArticles)
        }
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

                CycleHistoryChart(
                    entries: summary.chartEntries,
                    fallbackValue: summary.averageCycleLength,
                    calendar: calendar
                )

                if let currentCycleDay = summary.currentCycleDay {
                    HStack {
                        Text("Day \(currentCycleDay) of your cycle")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(hex: 0x3A3D58))
                        Spacer()
                        if let nextPeriodStart = summary.nextPredictedPeriodStart {
                            Text("Next period \(formatted(day: nextPeriodStart))")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color(hex: 0x8B7AAE))
                        }
                    }
                }
            }
            .padding(22)
        }
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



    private var moodContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            insightListCard(
                title: "Mood patterns",
                subtitle: "A quick view of your most common moods.",
                rows: topMoods.map { mood, count in
                    InsightRow(
                        title: moodTitle(mood),
                        detail: "\(count) logs",
                        tint: Color(hex: 0x9E86FF)
                    )
                },
                emptyMessage: "Start logging mood entries to build your mood trends."
            )

            articleSection(items: moodArticles)
        }
    }

    private func articleSection(items: [InsightArticle]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Articles for you")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: 0x202342))

            ForEach(items) { item in
                CardView {
                    HStack(spacing: 14) {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(item.gradient)
                            .frame(width: 92, height: 92)
                            .overlay {
                                Image(systemName: item.icon)
                                    .font(.system(size: 30, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.92))
                            }

                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.title)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(hex: 0x202342))

                            Text(item.subtitle)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundStyle(Color(hex: 0x70738A))
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color(hex: 0xB1A9C9))
                    }
                    .padding(16)
                }
            }
        }
    }
    
    private var loggedRecords: [DayRecord] {
        Array(logPeriodService.allLoggedDays())
    }

    private var insightSummary: CycleInsightSummary {
        cyclePredictionService.insightSummary(
            from: loggedRecords,
            defaultCycleLength: userStore.userData?.cylceLength ?? 28,
            defaultPeriodLength: userStore.userData?.periodLength ?? 5,
            referenceDate: Date()
        )
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

    private var calendarLabel: String {
        Date().formatted(.dateTime.month(.abbreviated).year())
    }

    private func formatted(day: LocalDay) -> String {
        guard let date = day.date(in: calendar) else {
            return "--"
        }

        return date.formatted(.dateTime.month(.abbreviated).day())
    }

    func symptomTitle(_ symptom: Symptom) -> String {
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

    private func moodTitle(_ mood: Mood) -> String {
        switch mood {
        case .happy:
            return "Happy"
        case .sad:
            return "Sad"
        case .irritated:
            return "Irritated"
        case .anxious:
            return "Anxious"
        case .calm:
            return "Calm"
        case .excited:
            return "Excited"
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
            )
        ]
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
            )
        ]
    }

    private var sleepArticles: [InsightArticle] {
        [
            InsightArticle(
                title: "Sleep during your cycle",
                subtitle: "Why energy levels change",
                icon: "sparkles",
                gradient: LinearGradient(
                    colors: [Color(hex: 0x1B3A6F), Color(hex: 0x7E8BFF)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            InsightArticle(
                title: "Evening routine reset",
                subtitle: "Simple ways to fall asleep faster",
                icon: "bed.double.fill",
                gradient: LinearGradient(
                    colors: [Color(hex: 0x4A5EBE), Color(hex: 0x8C9BFF)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        ]
    }
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

struct InsightRow: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let tint: Color
}

struct InsightArticle: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
}

private struct CycleHistoryChart: View {
    let entries: [CycleInsightSummary.ChartEntry]
    let fallbackValue: Int
    let calendar: Calendar

    private var displayEntries: [CycleInsightSummary.ChartEntry] {
        if entries.isEmpty {
            return [
                .init(
                    startDay: LocalDay(date: Date(), calendar: calendar),
                    cycleLength: max(fallbackValue, 1)
                )
            ]
        }

        return entries
    }

    private var maxValue: Double {
        Double(max(displayEntries.map(\.cycleLength).max() ?? fallbackValue, 1))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(Array(displayEntries.enumerated()), id: \.element.id) { index, entry in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: index == displayEntries.count - 1
                                        ? [Color(hex: 0xB39DFF), Color(hex: 0x7FA0FF)]
                                        : [Color(hex: 0xE0D2FF), Color(hex: 0xC7B5FF)],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(
                                width: 18,
                                height: max(CGFloat(Double(entry.cycleLength) / maxValue) * 120, 22)
                            )

                        Text(label(for: entry.startDay))
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(hex: 0xAAA6BE))
                    }
                    .frame(maxWidth: .infinity, alignment: .bottom)
                }
            }
            .frame(height: 150, alignment: .bottom)

            if entries.isEmpty {
                Text("Log at least two periods to unlock cycle trend history.")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(hex: 0x8B8FA7))
            }
        }
    }

    private func label(for day: LocalDay) -> String {
        guard let date = day.date(in: calendar) else {
            return "--"
        }

        return date.formatted(.dateTime.month(.narrow))
    }
}

#Preview {
    InsightsView()
        .environment(UserStore())
}

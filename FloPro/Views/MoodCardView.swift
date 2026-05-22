//
//  MoodCardView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 28/04/26.
//

import SwiftUI

struct MoodOption: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
}

struct MoodCardView: View {
    @Environment(LogPeriodStore.self) private var logPeriodStore
    
    private let logSymptomService: LogSymptomService
    private let moodOptions: [MoodItem] = Mood.allCases.map {
        .init(mood: $0)
    }
    private let calendar: Calendar
    private let now = Date()
    private let localDay: LocalDay
    
    init(logSymptomService: LogSymptomService = LogSymptomService()) {
        self.logSymptomService = logSymptomService
        self.calendar = .current
        self.localDay = LocalDay(year: calendar.component(.year, from: now), month: calendar.component(.month, from: now), day: calendar.component(.day, from: now))
    }
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Today")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x202342))
                
                Text("How are you feeling?")
                    .font(
                        .system(size: 18, weight: .semibold, design: .rounded)
                    )
                    .foregroundStyle(Color(hex: 0x202342))
                
                HStack(spacing: 0) {
                    ForEach(moodOptions) { mood in
                        Button {
                            let moodSel: Mood?
                            moodSel = todayRecord?.mood == mood.mood ? nil : mood.mood
                            logPeriodStore.logSymptoms(symptoms: nil, mood: moodSel, intensity: nil, day: self.localDay)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(todayRecord?.mood == mood.mood ? mood.tint.opacity(0.5) : mood.tint.opacity(0.12))
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: mood.icon)
                                    .font(.system(size: 26, weight: .medium))
                                    .foregroundStyle(mood.tint)
                            }.frame(maxWidth: .infinity)
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 2)
            }
            .padding(20)
        }
    }
    
    private var loggedRecords: [DayRecord] {
        Array(logPeriodStore.loggedDays.values)
    }
    
    private var todayRecord: DayRecord? {
        logPeriodStore.loggedDays[localDay]
    }
}

#Preview {
    MoodCardView()
        .environment(LogPeriodStore())
        .environment(UserStore())
}

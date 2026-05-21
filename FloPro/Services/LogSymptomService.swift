//
//  SymptomLogService.swift
//  FloPro
//
//  Created by Anirudh Sharma on 21/05/26.
//

import SwiftUI

struct LogSymptomService {
    let physicalSymptoms: [SymptomItem] = [
        .init(symptom: .cramps, title: "Cramps", icon: "bolt.fill", tint: Color(hex: 0xF59D62)),
        .init(symptom: .headache, title: "Headache", icon: "brain.head.profile", tint: Color(hex: 0x9581F2)),
        .init(symptom: .bloating, title: "Bloating", icon: "drop.fill", tint: Color(hex: 0xEF7D85)),
        .init(symptom: .acne, title: "Acne", icon: "circle.grid.2x2.fill", tint: Color(hex: 0xF38A6A)),
        .init(symptom: .fatigue, title: "Fatigue", icon: "sun.max.fill", tint: Color(hex: 0xF4B955)),
        .init(symptom: .backache, title: "Backache", icon: "figure.walk", tint: Color(hex: 0x8F79F1))
    ]

    let moods: [MoodItem] = [
        .init(mood: .happy, title: "Happy", icon: "face.smiling.fill", tint: Color(hex: 0x8A74F1)),
        .init(mood: .sad, title: "Sad", icon: "cloud.drizzle.fill", tint: Color(hex: 0x7C96F6)),
        .init(mood: .irritated, title: "Irritated", icon: "flame.fill", tint: Color(hex: 0xF58AA8)),
        .init(mood: .anxious, title: "Anxious", icon: "exclamationmark.circle.fill", tint: Color(hex: 0xF78BAB)),
        .init(mood: .calm, title: "Calm", icon: "leaf.fill", tint: Color(hex: 0xF3B85A)),
        .init(mood: .excited, title: "Excited", icon: "sparkles", tint: Color(hex: 0xF39A44))
    ]

    private let logPeriodService: LogPeriodService

    init(logPeriodService: LogPeriodService = LogPeriodService()) {
        self.logPeriodService = logPeriodService
    }
    
    func logSymptoms(
        symptoms: Set<Symptom>,
        mood: Mood?,
        intensity: SymptomIntensity,
        day: LocalDay
    ) {
        let currentRecord = logPeriodService.fetchDay(day)
        let updatedRecord = DayRecord(
            day: day,
            isPeriod: currentRecord?.isPeriod ?? false,
            periodFlow: currentRecord?.periodFlow,
            symptoms: symptoms.isEmpty ? nil : symptoms,
            mood: mood,
            symptomIntensity: symptoms.isEmpty && mood == nil ? nil : intensity
        )

        logPeriodService.logDay(updatedRecord)
    }
}

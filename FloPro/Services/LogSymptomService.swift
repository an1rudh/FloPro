//
//  SymptomLogService.swift
//  FloPro
//
//  Created by Anirudh Sharma on 21/05/26.
//

import SwiftUI

struct LogSymptomService {
    private let logPeriodService: LogPeriodService

    init(logPeriodService: LogPeriodService = LogPeriodService()) {
        self.logPeriodService = logPeriodService
    }
    
    var physicalSymptoms: [SymptomItem] {
        Symptom.allCases.map {
            SymptomItem(symptom: $0)
        }
    }

    var moods: [MoodItem] {
        Mood.allCases.map {
            MoodItem(mood: $0)
        }
    }
    
    func logSymptoms(
        symptoms: Set<Symptom>?,
        mood: Mood?,
        intensity: SymptomIntensity?,
        day: LocalDay
    ) {
        let currentRecord = logPeriodService.fetchDay(day)
        let updatedRecord = DayRecord(
            day: day,
            isPeriod: currentRecord?.isPeriod ?? false,
            periodFlow: currentRecord?.periodFlow,
            symptoms: symptoms ?? currentRecord?.symptoms ?? [],
            mood: mood ?? currentRecord?.mood,
            symptomIntensity: intensity ?? currentRecord?.symptomIntensity
        )

        logPeriodService.logDay(updatedRecord)
    }
}

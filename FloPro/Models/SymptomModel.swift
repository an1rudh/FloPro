//
//  SymptomModel.swift
//  FloPro
//
//  Created by Anirudh Sharma on 21/05/26.
//

import SwiftUI

struct SymptomItem: Identifiable {
    let symptom: Symptom
    let title: String
    let icon: String
    let tint: Color

    var id: Symptom { symptom }
}

struct MoodItem: Identifiable {
    let mood: Mood
    let title: String
    let icon: String
    let tint: Color

    var id: Mood { mood }
}

enum SymptomIntensity: String, CaseIterable, Codable, Hashable, Identifiable {
    case mild
    case moderate
    case severe

    var id: Self { self }

    var title: String {
        switch self {
        case .mild:
            return "Mild"
        case .moderate:
            return "Moderate"
        case .severe:
            return "Severe"
        }
    }
}

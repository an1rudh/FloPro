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

    init(symptom: Symptom) {
        self.symptom = symptom
        self.title = symptom.title
        self.icon = symptom.icon
        self.tint = symptom.tint
    }

    var id: Symptom { symptom }
}

struct MoodItem: Identifiable {
    let mood: Mood
    let title: String
    let icon: String
    let tint: Color
    init(mood: Mood) {
        self.mood = mood
        self.title = mood.title
        self.icon = mood.icon
        self.tint = mood.tint
    }
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

enum Symptom: String, CaseIterable, Codable, Hashable {
    case cramps = "cramps"
    case headache = "headache"
    case bloating = "bloating"
    case acne = "acne"
    case fatigue = "fatigue"
    case backache = "backache"

    var title: String {
        switch self {
        case .cramps: return "Cramps"
        case .headache: return "Headache"
        case .bloating: return "Bloating"
        case .acne: return "Acne"
        case .fatigue: return "Fatigue"
        case .backache: return "Backache"
        }
    }

    var icon: String {
        switch self {
        case .cramps: return "bolt.fill"
        case .headache: return "brain.head.profile"
        case .bloating: return "drop.fill"
        case .acne: return "circle.grid.2x2.fill"
        case .fatigue: return "sun.max.fill"
        case .backache: return "figure.walk"
        }
    }

    var tint: Color {
        switch self {
        case .cramps: return Color(hex: 0xF59D62)
        case .headache: return Color(hex: 0x9581F2)
        case .bloating: return Color(hex: 0xEF7D85)
        case .acne: return Color(hex: 0xF38A6A)
        case .fatigue: return Color(hex: 0xF4B955)
        case .backache: return Color(hex: 0x8F79F1)
        }
    }
}

enum Flow: String, CaseIterable, Codable, Hashable {
    case normal = "normal"
    case heavy = "heavy"
    case light = "light"
}

enum Mood: String, CaseIterable, Codable, Hashable {
    case happy = "happy"
    case sad = "sad"
    case irritated = "irritated"
    case anxious = "anxious"
    case calm = "calm"
    case excited = "excited"
    
    var title: String {
        switch self {
        case .happy: return "Happy"
        case .sad: return "Sad"
        case .irritated: return "Irritated"
        case .anxious: return "Anxious"
        case .calm: return "Calm"
        case .excited: return "Excited"
        }
    }
    
    var icon: String {
        switch self {
        case .happy: return "face.smiling.fill"
        case .sad: return "cloud.drizzle.fill"
        case .irritated: return "flame.fill"
        case .anxious: return "exclamationmark.circle.fill"
        case .calm: return "leaf.fill"
        case .excited: return "sparkles"
        }
    }
    
    var tint: Color {
        switch self {
        case .happy: return Color(hex: 0x8A74F1)
        case .sad: return Color(hex: 0x7C96F6)
        case .irritated: return Color(hex: 0xF58AA8)
        case .anxious: return Color(hex: 0xF78BAB)
        case .calm: return Color(hex: 0xF3B85A)
        case .excited: return Color(hex: 0xF39A44)
        }
    }
}

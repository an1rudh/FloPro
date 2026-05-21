//
//  DayRecord.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//

struct DayRecord: Codable, Hashable, Identifiable {
    let day: LocalDay
    let isPeriod: Bool
    var periodFlow: Flow?
    var symptoms: Set<Symptom>?
    var mood: Mood?
    var symptomIntensity: SymptomIntensity?
    
    var id: LocalDay { day }
}

enum Symptom: String, CaseIterable, Codable, Hashable {
    case cramps = "cramps"
    case headache = "headache"
    case bloating = "bloating"
    case acne = "acne"
    case fatigue = "fatigue"
    case backache = "backache"
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
}

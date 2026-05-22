//
//  DayRecord.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//

import SwiftUI

struct DayRecord: Codable, Hashable, Identifiable {
    let day: LocalDay
    let isPeriod: Bool
    var periodFlow: Flow?
    var symptoms: Set<Symptom>?
    var mood: Mood?

    var id: LocalDay { day }
}

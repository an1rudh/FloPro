//
//  CycleDataModel.swift
//  FloPro
//
//  Created by Anirudh Sharma on 28/04/26.
//

import Foundation
import Observation

@Observable
final class UserData: Codable {
    enum UserGoal: String, CaseIterable, Codable, Hashable {
        case trackCycle = "trackCycle"
        case getPregnant = "getPregnant"
        case avoidPregnancy = "avoidPregnancy"
        case understandMyHealth = "understandMyHealth"
        var title: String {
            switch self {
                case .trackCycle: return "Track Cycle"
                case .getPregnant: return "Get Pregnant"
                case .avoidPregnancy: return "Avoid Pregnancy"
                case .understandMyHealth: return "Understand My Health"
            }
        }
    }

    var name = ""
    var cylceLength: Int = 0
    var periodLength: Int = 0
    var age = 0
    var userGoal: UserGoal = .trackCycle
    var isUserOnboarded: Bool = false
    init(name: String = "", cylceLength: Int, periodLength: Int, age: Int = 0, userGoal: UserGoal, isUserOnboarded: Bool) {
        self.name = name
        self.cylceLength = cylceLength
        self.periodLength = periodLength
        self.age = age
        self.userGoal = userGoal
        self.isUserOnboarded = isUserOnboarded
    }
}



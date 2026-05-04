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
    enum UserGoal: String, CaseIterable, Codable {
        case trackCycle = "trackCycle"
    }

    var cylceLength: Int = 0
    var periodLength: Int = 0
    var age = 0
    var userGoal: UserGoal = .trackCycle

    init(cylceLength: Int, periodLength: Int, age: Int = 0, userGoal: UserGoal) {
        self.cylceLength = cylceLength
        self.periodLength = periodLength
        self.age = age
        self.userGoal = userGoal
    }
}

@Observable
final class UserStore {
    private let storageKey = "user_data"

    var userData: UserData? {
        didSet {
            persistUserData()
        }
    }

    init() {
        userData = loadUserData()
    }

    func save(_ userData: UserData) {
        self.userData = userData
    }

    func clear() {
        userData = nil
    }

    private func loadUserData() -> UserData? {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return nil
        }

        return try? JSONDecoder().decode(UserData.self, from: data)
    }

    private func persistUserData() {
        guard let userData else {
            UserDefaults.standard.removeObject(forKey: storageKey)
            return
        }

        guard let encodedData = try? JSONEncoder().encode(userData) else {
            return
        }

        UserDefaults.standard.set(encodedData, forKey: storageKey)
    }
}

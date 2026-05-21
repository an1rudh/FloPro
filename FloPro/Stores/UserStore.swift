//
//  UserStore.swift
//  FloPro
//
//  Created by Anirudh Sharma on 21/05/26.
//

import Observation
import Foundation

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

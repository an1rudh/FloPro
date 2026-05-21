//
//  FloProApp.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

@main
struct FloProApp: App {
    @State private var userStore = UserStore()
    @State private var periodLogStore = LogPeriodStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userStore)
                .environment(periodLogStore)
        }
    }
}

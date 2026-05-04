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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userStore)
        }
    }
}

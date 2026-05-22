//
//  ContentView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(UserStore.self) private var userStore

    var body: some View {
        if userStore.userData?.isUserOnboarded == false || userStore.userData?.isUserOnboarded == nil {
            OnboardingView()
        } else {
            NavigationStack {
                TabView {
                    Tab("Today", systemImage: "house") {
                        HomeScreenView()
                    }
                    Tab("Calendar", systemImage: "calendar") {
                        CalendarView(quickLog: false)
                    }
                    Tab("Insights", systemImage: "chart.bar") {
                        InsightsView()
                    }
                    Tab("Profile", systemImage: "person.fill") {
                        ProfileView()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(UserStore())
        .environment(LogPeriodStore())
}

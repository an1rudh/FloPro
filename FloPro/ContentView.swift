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
        if userStore.userData?.isUserOnboarded == false ||
            userStore.userData?.isUserOnboarded == nil {
            OnboardingView()
        } else {
            TabView {
                Tab("Today", systemImage: "house") {
                    NavigationStack {
                        HomeScreenView()
                    }
                }
                Tab("Calendar", systemImage: "calendar") {
                    NavigationStack {
                        CalendarView(quickLog: false)
                    }
                }
                Tab("Insights", systemImage: "chart.bar") {
                    NavigationStack {
                        InsightsView()
                    }
                }
                Tab("Profile", systemImage: "person.fill") {
                    NavigationStack {
                        ProfileView()
                    }
                }
            }
            .tint(AppColors.primaryPurple)
        }
    }
}

#Preview {
    ContentView()
        .environment(UserStore())
        .environment(LogPeriodStore())
}

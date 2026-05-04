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
        if false {
            OnboardingView(isUserOnboarded: .constant(false))
        } else {
            NavigationStack {
                TabView {
                    Tab("Today", systemImage: "house") {
                        HomeScreenView()
                    }
                    Tab("Calendar", systemImage: "calendar") {
                        CalendarView(quickLog: .constant(false))
                    }
                    Tab("Insights", systemImage: "chart.bar") {
                        
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
}

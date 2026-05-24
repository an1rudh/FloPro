//
//  HomeScreen.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct HomeScreenView: View {
    @Environment(UserStore.self) private var userStore
    var body: some View {
        ZStack {
            BackdropView()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 18) {
                    header
                    CycleCardView()
                    MoodCardView()
                    InsightsCardView()
                }
                .padding(.horizontal)
            }
        }

    }

    private var header: some View {
        HStack {
            Text("Good morning, \(userStore.userData?.name ?? "") 🌸")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: 0x202342))
            Spacer()
        }
    }
}

#Preview {
    HomeScreenView()
        .environment(UserStore())
        .environment(LogPeriodStore())
}

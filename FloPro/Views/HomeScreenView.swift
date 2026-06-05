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
        BackdropContainer {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    CycleCardView()
                    MoodCardView()
                    InsightsCardView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            }
        }
    }

    private var header: some View {
        HStack {
            Text("Hello, \(userStore.userData?.name ?? "") 🌸")
                .font(AppTypographies.largeTitle)
                .foregroundStyle(AppColors.primaryText)
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        HomeScreenView()
            .environment(UserStore())
            .environment(LogPeriodStore())
    }
}

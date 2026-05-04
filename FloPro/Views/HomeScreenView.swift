//
//  HomeScreen.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: 0xFFF9FB),
                    Color(hex: 0xFFF3F8),
                    Color(hex: 0xFFF9FD),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    CycleCardView()
                    MoodCardView()
                    InsightsCardView()
                }
                .padding(.horizontal, 22)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }

    }

    private var header: some View {
        HStack {
            Text("Good morning, Aditi 🌸")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: 0x202342))
            Spacer()
        }
        .padding(.top, 4)
    }
}

#Preview {
    HomeScreenView()
}

//
//  MoodCardView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 28/04/26.
//

import SwiftUI

struct MoodOption: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
}

struct MoodCardView: View {
    private let moodOptions: [MoodOption] = [
        MoodOption(icon: "face.smiling", color: Color(hex: 0xF8C766)),
        MoodOption(icon: "face.dashed", color: Color(hex: 0xF6CA72)),
        MoodOption(icon: "face.neutral", color: Color(hex: 0xF4C36B)),
        MoodOption(icon: "face.smiling.inverse", color: Color(hex: 0xF2B364)),
        MoodOption(icon: "exclamationmark.bubble.fill", color: Color(hex: 0xEE7D5E))
    ]
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Today")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x202342))

                Text("How are you feeling?")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x202342))

                HStack(spacing: 18) {
                    ForEach(moodOptions) { mood in
                        ZStack {
                            Circle()
                                .fill(mood.color)
                                .frame(width: 52, height: 52)

                            Image(systemName: mood.icon)
                                .font(.system(size: 26, weight: .medium))
                                .foregroundStyle(Color(hex: 0x6C5333))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 2)
            }
            .padding(20)
        }
    }
}

#Preview {
    MoodCardView()
}

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
    private let logSymptomService: LogSymptomService
    private let moodOptions: [MoodItem] = Mood.allCases.map {
        .init(mood: $0)
    }
    init(logSymptomService: LogSymptomService = LogSymptomService()) {
        self.logSymptomService = logSymptomService
    }
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Today")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x202342))

                Text("How are you feeling?")
                    .font(
                        .system(size: 18, weight: .semibold, design: .rounded)
                    )
                    .foregroundStyle(Color(hex: 0x202342))

                HStack(spacing: 0) {
                    ForEach(moodOptions) { mood in
                        Button {
//                            logSymptomService.logSymptoms(symptoms: nil, mood: mood, intensity: nil, day: <#T##LocalDay#>)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(mood.tint.opacity(0.12))
                                    .frame(width: 52, height: 52)

                                Image(systemName: mood.icon)
                                    .font(.system(size: 26, weight: .medium))
                                    .foregroundStyle(mood.tint)
                            }.frame(maxWidth: .infinity)
                        }

                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 2)
            }
            .padding(20)
        }
    }
}

#Preview {
    MoodCardView()
}

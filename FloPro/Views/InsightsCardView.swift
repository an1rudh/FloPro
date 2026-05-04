//
//  InsightsCardView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 28/04/26.
//

import SwiftUI

struct InsightsCardView: View {
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Insights for you")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x202342))

                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: 0xF8EDF7))
                            .frame(width: 54, height: 54)

                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color(hex: 0x9A70D1))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("You slept better")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: 0x202342))

                        Text("Great! Your sleep quality improved")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color(hex: 0x70738A))
                    }

                    Spacer()

                    HStack(alignment: .bottom, spacing: 6) {
                        ForEach([30.0, 22.0, 36.0, 16.0], id: \.self) { height in
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(Color(hex: 0x9587FF).opacity(0.75))
                                .frame(width: 6, height: height)
                        }
                    }
                    .frame(height: 40)
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    InsightsCardView()
}

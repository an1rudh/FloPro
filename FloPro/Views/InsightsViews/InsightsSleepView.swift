//
//  InsightsSleepView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//

import SwiftUI

struct InsightsSleepView: View {
    
    private var sleepArticles: [InsightArticle] {
        [
            InsightArticle(
                title: "Sleep during your cycle",
                subtitle: "Why energy levels change",
                icon: "sparkles",
                gradient: LinearGradient(
                    colors: [Color(hex: 0x1B3A6F), Color(hex: 0x7E8BFF)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            InsightArticle(
                title: "Evening routine reset",
                subtitle: "Simple ways to fall asleep faster",
                icon: "bed.double.fill",
                gradient: LinearGradient(
                    colors: [Color(hex: 0x4A5EBE), Color(hex: 0x8C9BFF)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sleep insights")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: 0x202342))

                    Text("Sleep tracking is not connected yet, but you can still use cycle timing to build better evening routines around your luteal phase.")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(hex: 0x70738A))

                    HStack(spacing: 12) {
                        sleepTip(icon: "moon.stars.fill", title: "Wind down earlier")
                        sleepTip(icon: "bed.double.fill", title: "Aim for a steady bedtime")
                    }
                }
                .padding(22)
            }

            ArticleCardView(items: sleepArticles)
        }
    }
    
    private func sleepTip(icon: String, title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(hex: 0x7F69C8))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(Color(hex: 0xEFE8FF))
                )

            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: 0x3A3D58))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    InsightsSleepView()
}

//
//  InsightsListCardView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//

import SwiftUI

struct InsightsListCardView: View {
    private var title: String
    private var subtitle: String
    private var rows: [InsightRow]
    private var emptyMessage: String

    init(
        title: String,
        subtitle: String,
        rows: [InsightRow],
        emptyMessage: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.rows = rows
        self.emptyMessage = emptyMessage
    }

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(
                            .system(size: 24, weight: .bold, design: .rounded)
                        )
                        .foregroundStyle(Color(hex: 0x202342))

                    Text(subtitle)
                        .font(
                            .system(size: 15, weight: .medium, design: .rounded)
                        )
                        .foregroundStyle(Color(hex: 0x70738A))
                }

                if rows.isEmpty {
                    Text(emptyMessage)
                        .font(
                            .system(size: 16, weight: .medium, design: .rounded)
                        )
                        .foregroundStyle(Color(hex: 0x8B8FA7))
                } else {
                    ForEach(rows) { row in
                        HStack(spacing: 14) {
                            Circle()
                                .fill(row.tint.opacity(0.2))
                                .frame(width: 42, height: 42)
                                .overlay {
                                    Circle()
                                        .fill(row.tint)
                                        .frame(width: 18, height: 18)
                                }

                            Text(row.title)
                                .font(
                                    .system(
                                        size: 17,
                                        weight: .semibold,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(Color(hex: 0x202342))

                            Spacer()

                            Text(row.detail)
                                .font(
                                    .system(
                                        size: 15,
                                        weight: .medium,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(Color(hex: 0x8B8FA7))
                        }
                    }
                }
            }
            .padding(22)
        }
    }
}

#Preview {
    //    InsightsListCardView(title: "Test", subtitle: "Test", rows: <#T##[InsightRow]#>, emptyMessage: "test")
}

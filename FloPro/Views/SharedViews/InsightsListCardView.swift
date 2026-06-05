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
                        .font(AppTypographies.title)
                        .foregroundStyle(AppColors.primaryText)

                    Text(subtitle)
                        .font(AppTypographies.caption)
                        .foregroundStyle(AppColors.secondaryText)
                }

                if rows.isEmpty {
                    Text(emptyMessage)
                        .font(AppTypographies.body)
                        .foregroundStyle(AppColors.primaryText)
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
                                .font(AppTypographies.body)
                                .foregroundStyle(AppColors.primaryText)

                            Spacer()

                            Text(row.detail)
                                .font(AppTypographies.caption)
                                .foregroundStyle(AppColors.secondaryText)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    //    InsightsListCardView(title: "Test", subtitle: "Test", rows: <#T##[InsightRow]#>, emptyMessage: "test")
}

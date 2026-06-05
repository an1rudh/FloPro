//
//  InsightsView.swift
//  FloPro
//
//  Created by Codex on 06/05/26.
//

import SwiftUI

struct InsightsView: View {
    @Environment(LogPeriodStore.self) private var logPeriodStore
    @State private var selectedSection: InsightSection = .overview

    var body: some View {
        BackdropContainer {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    sectionPicker
                    switch selectedSection {
                    case .overview:
                        InsightsOverviewView(loggedRecords: logPeriodStore.loggedRecords)
                    case .symptoms:
                        InsightsSymptomsView(loggedRecords: logPeriodStore.loggedRecords)
                    case .mood:
                        InsightsMoodView(loggedRecords: logPeriodStore.loggedRecords)
                    case .sleep:
                        InsightsSleepView()
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                header
            }
        }
    }

    private var header: some View {
            Text("Insights")
            .font(AppTypographies.title)
    }

    private var sectionPicker: some View {
        HStack {
            Spacer()
            ForEach(InsightSection.allCases, id: \.self) { section in
                Button {
                    selectedSection = section
                } label: {
                    Text(section.title)
                        .font(AppTypographies.caption)
                        .foregroundStyle(
                            selectedSection == section
                            ? AppColors.contrastText
                            : AppColors.primaryText
                        )
                        .lineLimit(1)
                        .frame(width: 84, height: 38)
                        .background(
                            Capsule(style: .circular)
                                .fill(
                                    selectedSection == section
                                    ? AppColors.primaryPurple
                                    : AppColors.cardBackground
                                )
                        )
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
    }
}


#Preview {
    NavigationStack {
        InsightsView()
            .environment(UserStore())
            .environment(LogPeriodStore())
    }
}

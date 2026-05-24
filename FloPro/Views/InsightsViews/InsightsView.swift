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
        ZStack {
            BackdropView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    header
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
                .padding(.horizontal)
            }
        }
    }

    private var header: some View {
        HStack {
            Spacer()
            Text("Insights")
                .font(.system(size: 28, weight: .bold, design: .rounded))
            Spacer()
        }
    }

    private var sectionPicker: some View {
        HStack {
            Spacer()
            ForEach(InsightSection.allCases, id: \.self) { section in
                Button {
                    selectedSection = section
                } label: {
                    Text(section.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(
                            selectedSection == section
                                ? Color(hex: 0x8F71D9)
                                : Color(hex: 0x70738A)
                        )
                        .lineLimit(1)
                        .frame(width: 85, height: 38)
                        .background(
                            Capsule(style: .circular)
                                .fill(
                                    selectedSection == section
                                        ? Color(hex: 0xEEE7FF)
                                        : Color.white
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
    InsightsView()
        .environment(UserStore())
        .environment(LogPeriodStore())
}

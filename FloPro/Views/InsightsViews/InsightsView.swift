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
                        InsightsOverviewView(loggedRecords: loggedRecords)
                    case .symptoms:
                        InsightsSymptomsView(loggedRecords: loggedRecords)
                    case .mood:
                        InsightsMoodView(loggedRecords: loggedRecords)
                    case .sleep:
                        InsightsSleepView()
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
    }
    
    private var loggedRecords: [DayRecord] {
        Array(logPeriodStore.loggedDays.values)
    }

    private var header: some View {
        HStack {
            Spacer()
            Text("Insights")
                .font(.system(size: 28, weight: .bold))
            Spacer()
        }
        .padding(.top, 4)
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
                        .frame(height: 38)
                        .padding(.horizontal, 10)
                        .background(
                            Capsule(style: .continuous)
                                .fill(
                                    selectedSection == section
                                        ? Color(hex: 0xEEE7FF)
                                        : Color.white.opacity(0.72)
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

//
//  CycleCardView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 28/04/26.
//

import SwiftUI

struct CycleCardView: View {
    @Environment(LogPeriodStore.self) private var logPeriodStore
    @Environment(UserStore.self) private var userStore

    private let cyclePredictionService: CyclePredictionService
    
    init(cyclePredictionService: CyclePredictionService = CyclePredictionService()) {
        self.cyclePredictionService = cyclePredictionService
    }

    var body: some View {
        CardView {
            VStack {
                if hasLoggedData {
                    progressContent
                } else {
                    emptyStateContent
                }

                NavigationLink {
                    CalendarView(quickLog: .constant(true))
                } label : {
                    Text("Log Your Period")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: 0xEB4E88))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .padding(.horizontal, 24)
            }
            .padding()
        }
    }
    
    private var cycleSummary: CycleInsightSummary? {
        return cyclePredictionService.insightSummary(
            from: logPeriodStore.loggedRecords,
            defaultCycleLength: userStore.userData?.cylceLength ?? 28,
            defaultPeriodLength: userStore.userData?.periodLength ?? 5,
            referenceDate: Date()
        )
    }

    private var hasLoggedData: Bool {
        !logPeriodStore.loggedDays.isEmpty
    }

    private var periodInDays: Int {
        cyclePredictionService.nextPeriodInDays(
            from: logPeriodStore.loggedRecords,
            defaultCycleLength: userStore.userData?.cylceLength ?? 28,
            referenceDate: Date()
        )
    }
    
    private var progress: CGFloat {
        let currentCycleDay = cycleSummary?.currentCycleDay ?? 1
        let cycleLength = cycleSummary?.averageCycleLength ?? 28
        return CGFloat(currentCycleDay) / CGFloat(cycleLength)
    }

    private var progressContent: some View {
        ZStack {
            ArcProgressView(progress: progress)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(hex: 0xF04F90),
                            Color(hex: 0xEF7AA8),
                            Color(hex: 0xF7D3DA)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .frame(width: 240, height: 145)
                .padding(.bottom, 100)

            VStack(spacing: 6) {
                Text("Period in")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x4B4E68))

                Text(String(periodInDays))
                    .font(.system(size: 66, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x1A2143))

                Text("days")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(hex: 0x4B4E68))

                HStack(spacing: 6) {
                    Text("Day \(cycleSummary?.currentCycleDay ?? 0) of \(cycleSummary?.averageCycleLength ?? 0)")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(hex: 0x4B4E68))

                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(hex: 0x7A7D93))
                }
            }
            .padding(.top, 42)
        }
    }

    private var emptyStateContent: some View {
        Text("Start logging your cycle to see progress here")
            .font(.system(size: 22, weight: .semibold, design: .rounded))
            .foregroundStyle(Color(hex: 0x4B4E68))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .frame(height: 245)
            .padding(.horizontal, 24)
    }
}

#Preview {
    CycleCardView()
        .environment(UserStore())
        .environment(LogPeriodStore())
}

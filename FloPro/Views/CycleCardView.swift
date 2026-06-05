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
            VStack(alignment: .center, spacing: 30) {
                if hasLoggedData {
                    arcContainer
                } else {
                    emptyStateContent
                }
                logButton
            }
            .padding()
        }
    }
    
    private var logButton: some View {
        NavigationLink {
            CalendarView(quickLog: true)
        } label : {
            Text("Log Your Period")
                .font(AppTypographies.title2)
                .foregroundStyle(AppColors.contrastText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    AppColors.tertiaryGradient
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.22),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
        }
        .padding(.horizontal, 36)
    }
    
    private var arcContainer: some View {
        ZStack {
            ZStack {
                ArcProgressView(progress: 1)
                    .stroke(
                        AppColors.border,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                
                ArcProgressView(progress: progress)
                    .stroke(
                        AppColors.primaryGradient,
                        style: StrokeStyle(
                            lineWidth: 18,
                            lineCap: .round
                        )
                    )
                    .blur(radius: 12)
                    .opacity(0.4)
                
                ArcProgressView(progress: progress)
                    .stroke(
                        AppColors.primaryGradient,
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                
                ArcProgressView(progress: progress)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.4),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round
                        )
                    )
                    .blur(radius: 2)
            }
            .frame(width: 250, height: 250)
            .padding(.top)
            cardContent
        }
    }
    
    private var cardContent: some View {
        VStack(spacing: 10) {
            Text("Day \(cycleSummary?.currentCycleDay ?? 0) of \(cycleSummary?.averageCycleLength ?? 0)")
                .font(AppTypographies.body)
                .foregroundStyle(AppColors.secondaryText)
            
            Text("Follicular")
                .font(AppTypographies.largeTitle)
                .foregroundStyle(AppColors.primaryText)
            
            
            Text("Period in \(periodInDays) days")
                .font(AppTypographies.body)
                .foregroundStyle(AppColors.secondaryText)
            
        }
    }

    private var emptyStateContent: some View {
        Text("Start logging your cycle to see progress here")
            .font(AppTypographies.body)
            .foregroundStyle(AppColors.primaryText)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .frame(height: 245)
            .padding(.horizontal, 24)
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
}

#Preview {
    BackdropContainer {
        CycleCardView()
            .environment(UserStore())
            .environment(LogPeriodStore())
    }
}

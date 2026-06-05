//
//  CalendarView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct CalendarView: View {
    @Environment(LogPeriodStore.self) private var logPeriodStore
    @Environment(UserStore.self) private var userStore
    @State private var calendarViewModel = CalendarViewModel()
    @Namespace private var legendAnimation
    var quickLog: Bool
    
    init(quickLog: Bool) {
        self.quickLog = quickLog
        calendarViewModel.generateMonths()
    }
    
    var body: some View {
        BackdropContainer {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    calendarContainer
                        .simultaneousGesture(
                            TapGesture().onEnded {
                                if !calendarViewModel.isLegendCollapsed {
                                    withAnimation(
                                        .spring(response: 0.35, dampingFraction: 0.82)
                                    ) {
                                        calendarViewModel.isLegendCollapsed = true
                                    }
                                }
                            }
                        )
                    floatingLegend
                        .padding(.trailing)
                        .padding(.bottom)
                }
            }
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                header
            }
        }        .onAppear {
            syncCalendarState()
        }
        .onChange(of: logPeriodStore.loggedDays) {
            syncCalendarState()
        }
    }
    
    private func syncCalendarState() {
        calendarViewModel.setLoggedDays(
            logPeriodStore.loggedDays,
            userData: userStore.userData
        )
    }
    
    @ViewBuilder
    private var floatingLegend: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                calendarViewModel.isLegendCollapsed.toggle()
            }
        } label: {
            ZStack {
                calendarLegend
                    .opacity(
                        calendarViewModel.isLegendCollapsed ? 0 : 1
                    )
                Image(systemName: "info.circle")
                    .font(AppTypographies.title)
                    .foregroundStyle(AppColors.primaryText)
                    .opacity(
                        calendarViewModel.isLegendCollapsed ? 1 : 0
                    )
            }
            .padding(calendarViewModel.isLegendCollapsed ? 0 : 16)
            .frame(
                width: calendarViewModel.isLegendCollapsed ? 70 : 260,
                height: calendarViewModel.isLegendCollapsed ? 70 : nil
            )
            .background(
                calendarViewModel.isLegendCollapsed
                ? AnyShapeStyle(Color.white)
                : AnyShapeStyle(.ultraThinMaterial)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: calendarViewModel.isLegendCollapsed ? 70 : 20
                )
            )
            .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 6)
            .shadow(color: .white.opacity(0.7), radius: 1, x: 0, y: 1)
        }
    }
    
    @ViewBuilder
    private var calendarContainer: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(
                        calendarViewModel.monthArray,
                        id: \.self
                    ) { month in
                        VStack(spacing: 0) {
                            Color.clear
                                .background {
                                    GeometryReader { geo in
                                        Color.clear.preference(
                                            key: ScrollOffsetPreferenceKey.self,
                                            value: geo.frame(in: .global).minY
                                        )
                                    }
                                }
                            calendarHeader(month: month)
                                .padding(.bottom)
                            weekRow
                            calendarCells(month: month)
                            Divider()
                                .padding(.vertical)
                        }
                        .id(month)
                    }
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                calendarViewModel.handleScroll(offset)
            }
            .scrollIndicators(.hidden)
            .onAppear {
                DispatchQueue.main.async {
                    proxy.scrollTo(
                        calendarViewModel.currentMonth,
                        anchor: .top
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private var header: some View {
        Text("Calendar").font(.system(size: 28, weight: .bold, design: .rounded))
        
    }
    
    @ViewBuilder
    private func calendarHeader(month: Date) -> some View {
        HStack {
            if month == calendarViewModel.currentMonth {
                Image(systemName: "calendar").font(AppTypographies.title2).foregroundStyle(AppColors.brightPurple)
            }
            Text(month.formatted(.dateTime.month(.abbreviated).year()))
                .font(AppTypographies.title2)
                .padding(.horizontal, 4)
            Spacer()
        }.onAppear {
            calendarViewModel.onScroll(to: month)
        }
    }
    
    @ViewBuilder
    private var weekRow: some View {
        LazyVGrid(
            columns: calendarViewModel.columns,
            spacing: 12
        ) {
            ForEach(
                calendarViewModel.weekDays.enumerated(),
                id: \.offset
            ) { index, day in
                Text(day).font(AppTypographies.bodyEmphasis).foregroundStyle(AppColors.primaryText)
            }
        }
        .padding(.bottom, 4)
    }
    
    
    @ViewBuilder
    private func calendarCells(month: Date) -> some View {
        LazyVGrid(
            columns: calendarViewModel.columns,
            spacing: 12
        ) {
            ForEach(
                Array(calendarViewModel.calendarDayCells(for: month).enumerated()),
                id: \.offset
            ) { _, day in
                if let day {
                    calendarDayButton(for: day)
                } else {
                    Color.clear.frame(width: 36, height: 36)
                }
            }
        }
    }
    
    @ViewBuilder
    private var calendarLegend: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 120), alignment: .leading)],
            alignment: .leading,
            spacing: 10
        ) {
            ForEach(CalendarItems.LegendItemTitle.allCases, id: \.self) {
                title in
                legendItem(title: title)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func calendarDayButton(for day: LocalDay) -> some View {
        Group {
            if quickLog {
                Button {
                    logPeriodStore.logPeriod(for: day)
                    syncCalendarState()
                } label: {
                    dayCellLabel(of: day)
                }
            } else {
                NavigationLink {
                    SymptomLogView(day: day)
                } label: {
                    dayCellLabel(of: day)
                }
            }
        }.allowsHitTesting(calendarViewModel.isLegendCollapsed)
    }
    
    @ViewBuilder
    private func dayCellLabel(of day: LocalDay) -> some View {
        Text("\(day.day)")
            .frame(width: 45, height: 45)
            .foregroundColor(AppColors.secondaryText)
            .background(calendarViewModel.getBackgroundColor(for: day))
            .clipShape(.circle)
            .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 6)
            .shadow(color: .white.opacity(0.7), radius: 1, x: 0, y: 1)
            .overlay {
                if calendarViewModel.isToday(day) {
                    Circle().stroke(
                        AppColors.primaryText,
                        style: StrokeStyle(lineWidth: 0.8)
                    )
                }
            }
            .overlay(alignment: .topTrailing) {
                if calendarViewModel.showOvulationIndicator(for: day) {
                    Image(
                        systemName: CalendarItems.LegendItemTitle.ovulation
                            .symbol ?? ""
                    )
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(
                        CalendarItems.LegendItemTitle.ovulation.symbolColor
                        ?? .primary
                    )
                    .offset(x: 2, y: -0.5)
                }
            }
            .overlay(alignment: .bottom) {
                if logPeriodStore.record(for: day)?.symptoms != nil && logPeriodStore.record(for: day)?.mood != nil {
                    Image(
                        systemName: CalendarItems.LegendItemTitle.symptomsLogged
                            .symbol ?? ""
                    )
                    .font(.system(size: 6, weight: .medium))
                    .foregroundStyle(
                        CalendarItems.LegendItemTitle.symptomsLogged.symbolColor
                        ?? .primary
                    )
                    .offset(x: 0, y: -5)
                }
            }
        
    }
    
    @ViewBuilder
    private func legendItem(title: CalendarItems.LegendItemTitle) -> some View {
        HStack(alignment: .center) {
            Group {
                if let symbol = title.symbol {
                    let size = title == CalendarItems.LegendItemTitle.symptomsLogged ? 8 : 18
                    let symbolColor = title.symbolColor!
                    Image(systemName: symbol)
                        .font(.system(size: CGFloat(size), weight: .bold))
                        .foregroundStyle(symbolColor)
                        .frame(width: 20, height: 20)
                } else {
                    Circle()
                        .fill(title.color)
                        .frame(width: 20, height: 20)
                        .overlay {
                            if title == .today {
                                Circle().stroke(
                                    Color.black,
                                    style: StrokeStyle(lineWidth: 1)
                                )
                            }
                        }
                }
            }
            
            Text(title.title)
                .font(AppTypographies.body)
                .foregroundStyle(AppColors.primaryText)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

#Preview {
    NavigationStack {
        CalendarView(quickLog: true)
            .environment(UserStore())
            .environment(LogPeriodStore())
    }
}

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
    var quickLog: Bool
    
    var body: some View {
        ZStack {
            BackdropView()
            VStack {
                ZStack {
                    backButton
                    calendarHeader
                }
                weekRow
                calendarCells
                calendarLegend
                    .padding(.vertical)
                Spacer()
            }.padding()
            
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
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
    private var calendarHeader: some View {
        HStack {
            Button {
                calendarViewModel.changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left").font(.title2)
                    .foregroundColor(.black)
            }
            Text(calendarViewModel.currentMonth.formatted(.dateTime.month(.abbreviated).year()))
                .font(.title).fontWeight(.bold).padding(
                    .horizontal,
                    2
                )
            Button {
                calendarViewModel.changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right").font(.title2)
                    .foregroundColor(.black)
            }
            
        }
    }
    
    @ViewBuilder
    private var backButton: some View {
        if quickLog {
            HStack {
                BackButtonView()
                Spacer()
            }
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
                Text(day).fontWeight(.bold).font(.title2)
            }
        }
    }
    
    @ViewBuilder
    private var calendarCells: some View {
        LazyVGrid(
            columns: calendarViewModel.columns,
            spacing: 12
        ) {
            ForEach(
                Array(calendarViewModel.calendarDayCells().enumerated()),
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
    }
    
    @ViewBuilder
    private func dayCellLabel(of day: LocalDay) -> some View {
        Text("\(day.day)")
            .fontWeight(.semibold)
            .frame(width: 45, height: 45)
            .foregroundColor(.gray)
            .background(calendarViewModel.getBackgroundColor(for: day))
            .clipShape(.circle)
            .shadow(
                color: .black.opacity(0.06),
                radius: 6,
                x: 0,
                y: 2
            )
            .overlay {
                if calendarViewModel.isToday(day) {
                    Circle().stroke(
                        Color.black,
                        style: StrokeStyle(lineWidth: 1)
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
                    let size = title == CalendarItems.LegendItemTitle.symptomsLogged ? 8 : 14
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
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

#Preview {
    CalendarView(quickLog: false)
        .environment(UserStore())
        .environment(LogPeriodStore())
}

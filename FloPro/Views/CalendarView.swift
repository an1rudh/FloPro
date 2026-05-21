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
    @State private var calendarItems = CalendarItems()
    @Binding var quickLog: Bool
    var body: some View {
        ZStack {
            BackdropView()
            ScrollView {
                VStack {
                    ZStack {
                        if quickLog {
                            HStack {
                                BackButtonView()
                                Spacer()
                            }
                        }
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
                    LazyVGrid(
                        columns: calendarViewModel.columns,
                        spacing: 12
                    ) {
                        ForEach(
                            Array(
                                calendarViewModel.calendarDayCells()
                                    .enumerated()
                            ),
                            id: \.offset
                        ) {
                            _,
                            calDayCell in
                            if calDayCell == nil {
                                Color.clear.frame(width: 36, height: 36)
                            } else {
                                if quickLog {
                                    Button {
                                        logPeriodStore.logPeriod(for: calDayCell!.day)
                                        syncCalendarState()
                                    } label: {
                                        dayCellLabel(for: calDayCell!.dayNumber, of: calDayCell!.day)
                                    }
                                } else {

                                    NavigationLink {
                                        SymptomLogView(day: calDayCell!.day)
                                    } label: {
                                        dayCellLabel(for: calDayCell!.dayNumber, of: calDayCell!.day)
                                    }
                                }
                            }
                        }
                    }
                    if !quickLog {
                        calendarLegend
                            .padding(.vertical, 20)
                    }
                }.padding()

            }
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
    private func dayCellLabel(for dayNumber: Int, of day: LocalDay) -> some View {
        Text("\(dayNumber)")
            .fontWeight(.semibold)
            .frame(width: 45, height: 45)
            .foregroundColor(.gray)
            .background(calendarViewModel.getBackgroundColor(for: day))
            .clipShape(.circle)
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

    }

    @ViewBuilder
    private func legendItem(title: CalendarItems.LegendItemTitle) -> some View {
        HStack(alignment: .center) {
            Group {
                if let symbol = title.symbol {
                    let symbolColor = title.symbolColor!
                    Image(systemName: symbol)
                        .font(.system(size: 14, weight: .bold))
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
    CalendarView(quickLog: .constant(false))
        .environment(UserStore())
        .environment(LogPeriodStore())
}

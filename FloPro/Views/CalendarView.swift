//
//  CalendarView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var calendarViewModel = CalendarViewModel()
    @Binding var quickLog: Bool
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: 0xFFF9FB),
                    Color(hex: 0xFFF3F8),
                    Color(hex: 0xFFF9FD),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()

            ScrollView {
                VStack {
                    HStack {
                        Button {
                            calendarViewModel.changeMonth(by: -1)
                        } label: {
                            Image(systemName: "chevron.left").font(.title2)
                                .foregroundColor(.black)
                        }
                        Text(calendarViewModel.monthYearString(from: nil))
                            .font(
                                .title
                            ).fontWeight(.bold).padding(.horizontal)
                        Button {
                            calendarViewModel.changeMonth(by: 1)
                        } label: {
                            Image(systemName: "chevron.right").font(.title2)
                                .foregroundColor(.black)
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
                            calendarViewModel.getMonthArray().enumerated(),
                            id: \.offset
                        ) {
 index,
 dayDate in
                            if dayDate.0 == 0 {
                                Color.clear.frame(width: 36, height: 36)
                            } else {
                                if quickLog {
                                    Button {
                                        calendarViewModel
                                            .logPeriod(for: dayDate.1!)
                                    } label : {
                                        Text("\(dayDate.0)")
                                            .font(.title3).frame(
                                                width: 45,
                                                height: 45
                                            )
                                            .foregroundStyle(.black)
                                            .background(
                                                calendarViewModel
                                                    .getBackgroundColor(
                                                        date: dayDate.1!
                                                    )
                                            )
                                            .clipShape(
                                                .circle
                                            )
                                    }
                                } else {
                                    
                                    NavigationLink {
                                        SymptomLogView()
                                    } label: {
                                        Text("\(dayDate.0)").fontWeight(.bold)
                                            .buttonStyle(
                                                .plain
                                            ).font(.title3).frame(
                                                width: 45,
                                                height: 45
                                            )
                                            .background(
                                                calendarViewModel
                                                    .getBackgroundColor(
                                                        date: dayDate.1!
                                                    )
                                            )
                                            .clipShape(
                                                .circle
                                            )
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

    }

    private var calendarLegend: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 28) {
                legendItem(
                    color: Color(hex: 0xF7A8C8),
                    title: "Period"
                )
                legendItem(
                    color: Color(hex: 0xD9E6FF),
                    title: "Fertile Window"
                )
                legendItem(
                    symbol: "sparkle",
                    symbolColor: Color(hex: 0xF7B238),
                    title: "Ovulation"
                )
            }

            legendItem(
                color: Color(hex: 0xFBE9EF),
                title: "Today"
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func legendItem(
        color: Color? = nil,
        symbol: String? = nil,
        symbolColor: Color = .primary,
        title: String
    ) -> some View {
        HStack(spacing: 10) {
            Group {
                if let color {
                    Circle()
                        .fill(color)
                        .frame(width: 20, height: 20)
                } else if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(symbolColor)
                        .frame(width: 20, height: 20)
                }
            }

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    CalendarView(quickLog: .constant(true))
}

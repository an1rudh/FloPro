//
//  CycleCardView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 28/04/26.
//

import SwiftUI

struct CycleCardView: View {
    var body: some View {
            CardView {
                VStack {
                    ZStack {
                        ArcProgressView(progress: 0.78)
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

                            Text("3")
                                .font(.system(size: 66, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(hex: 0x1A2143))

                            Text("days")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundStyle(Color(hex: 0x4B4E68))
                            Text("Low chance")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color(hex: 0x636780))

                            HStack(spacing: 6) {
                                Text("Day 25 of 28")
                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color(hex: 0x4B4E68))

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color(hex: 0x7A7D93))
                            }
                        }
                        .padding(.top, 42)
                    }
                    NavigationLink {
                        CalendarView(quickLog: .constant(true))
                    } label : {
                        Text("Log Your Period")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: 0xF46EA2), Color(hex: 0xEB4E88)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .padding(.horizontal, 24)
                    
                }.padding()
            }
    }
}

#Preview {
    CycleCardView()
}

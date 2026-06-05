//
//  ArcProgressView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 28/04/26.
//

import SwiftUI

struct ArcProgressView: Shape {
    let progress: CGFloat

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startAngle = Angle.degrees(-90)
        let endAngle = Angle.degrees(270)
        let currentAngle = Angle.degrees(205 + (130 * progress))

        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: currentAngle,
            clockwise: false
        )

        path.addArc(
            center: center,
            radius: radius,
            startAngle: currentAngle,
            endAngle: endAngle,
            clockwise: false
        )

        return path.trimmedPath(from: 0, to: progress)
    }
}

#Preview {
    ArcProgressView(progress: 0.5)
        .stroke(AppColors.primaryGradient, style: StrokeStyle(lineWidth: 20, lineCap: .round))
        .frame(width: 240, height: 240)
}

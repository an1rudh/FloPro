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
        let radius = min(rect.width, rect.height * 2) / 2
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let startAngle = Angle.degrees(150)
        let endAngle = Angle.degrees(400)
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
        .stroke(.pink, style: StrokeStyle(lineWidth: 10))
        .frame(width: 240, height: 145)
}

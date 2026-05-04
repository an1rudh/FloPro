//
//  CardView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 28/04/26.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.white)
                    .shadow(
                        color: Color.black.opacity(0.05),
                        radius: 24,
                        x: 0,
                        y: 12
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.85), lineWidth: 1)
            )
    }
}

#Preview {
    CardView {
        Text("Test")
    }
}

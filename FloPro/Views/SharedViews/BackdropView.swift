//
//  BackdropView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//

import SwiftUI

struct BackdropView: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(hex: 0xFFF9FB),
                Color(hex: 0xFFF3F8),
                Color(hex: 0xFFF9FD),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).ignoresSafeArea()
    }
}

struct BackdropContainer<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            BackdropView()
            content
        }
    }
}

#Preview {
    BackdropView()
}

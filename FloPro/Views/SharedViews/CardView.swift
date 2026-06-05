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
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(AppColors.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 6)
                    .shadow(color: .white.opacity(0.7), radius: 1, x: 0, y: 1)
            )
    }
}

#Preview {
    BackdropContainer {
        CardView {
            Text("Test")
                .padding()
        }
    }
}

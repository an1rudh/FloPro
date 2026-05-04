//
//  OnboardingView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct OnboardingView: View {
    @State var showSplash: Bool = true
    @Binding var isUserOnboarded: Bool
    var body: some View {
        if showSplash {
            SplashScreen()
                .task {
                    try? await Task.sleep(for: .seconds(2))
                    showSplash = false
                }
        } else {
            HomeScreenView()
        }
    }
}

#Preview {
    OnboardingView(isUserOnboarded: .constant(false))
}

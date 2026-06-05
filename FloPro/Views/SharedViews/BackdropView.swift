//
//  BackdropView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//

import SwiftUI

struct BackdropView: View {
    var body: some View {
        AppColors.primaryBackground
            .ignoresSafeArea()
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

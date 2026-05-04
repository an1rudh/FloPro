//
//  SplashScreen.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack {
                Spacer()
                Image(systemName: "heart.fill")
                Text("FlowPro")
                Spacer()
                Spacer()
            }.font(.system(size: 60))
        }
    }
}

#Preview {
    SplashScreen()
}

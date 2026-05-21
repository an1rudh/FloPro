//
//  BackButtonView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 05/05/26.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(hex: 0x44405B))
                .frame(width: 36, height: 36)
                .background(Color.white.opacity(0.8), in: Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BackButtonView()
}

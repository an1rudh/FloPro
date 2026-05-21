//
//  ArticleView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 21/05/26.
//

import SwiftUI

struct ArticleCardView: View {
    let items: [InsightArticle]
    var body: some View {
            VStack(alignment: .leading, spacing: 14) {
                Text("Articles for you")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x202342))

                ForEach(items) { item in
                    CardView {
                        HStack(spacing: 14) {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(item.gradient)
                                .frame(width: 92, height: 92)
                                .overlay {
                                    Image(systemName: item.icon)
                                        .font(.system(size: 30, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.92))
                                }

                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.title)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(hex: 0x202342))

                                Text(item.subtitle)
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color(hex: 0x70738A))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Color(hex: 0xB1A9C9))
                        }
                        .padding(16)
                    }
                }
            }
        
    }
}
//
//#Preview {
//    ArticleView()
//}

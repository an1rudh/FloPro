//
//  AboutView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 25/05/26.
//

import SwiftUI

struct AboutView: View {
    private let documentationMenuItems: [DocumentationItemStruct] = DocumentationItem.allCases.map {
        .init(type: $0)
    }
    var body: some View {
        BackdropContainer {
            VStack(alignment: .leading, spacing: 30) {
                iconSection
                documentationSection
                rightsSection
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                header
            }
        }
    }
    
    private var header: some View {
        Text("About FloPro")
            .font(.system(size: 28, weight: .bold, design: .rounded))
        
    }
    
    private var iconSection: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 5) {
                CardView {
                    Image(systemName: "bird")
                        .resizable()
                        .foregroundStyle(.red)
                        .padding()
                }.frame(width: 200, height: 200)
                Text("FloPro")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                Text("Version 1.0.0")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
                Text("Your personal health companion")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
    
    private var documentationSection: some View {
        CardView {
            VStack(spacing: 0) {
                ForEach(Array(documentationMenuItems.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Image(systemName: item.icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.secondary)
                        Text(item.title)
                            .font(.system(size: 18, weight: .medium))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.gray)
                    }.padding()
                    if index < documentationMenuItems.count - 1 {
                        Divider()
                            .padding(.leading, 60)
                    }
                }
            }
        }
    }
    
    private var rightsSection: some View {
        Text("© 2026 FloPro. All rights reserved.")
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundStyle(.secondary)
    }
    
}

#Preview {
    NavigationStack {
        AboutView()
    }
}

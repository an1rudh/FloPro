//
//  HelpAndSupportView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 25/05/26.
//

import SwiftUI

struct HelpAndSupportView: View {
    
    private let helpCenterMenuItems: [HelpCenterMenuItemStruct] = HelpCenterMenuItem.allCases.map { item in
            .init(type: item)
    }
    
    private let communityMenuItems: [CommunityMenuItemStruct] =
    CommunityMenuItem.allCases.map { item in
            .init(type: item)
    }
    
    var body: some View {
        BackdropContainer {
            VStack(alignment: .leading, spacing: 30) {
                helpCenterSection
                communitySection
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                header
            }
        }
    }
    
    private var helpCenterSection: some View {
        VStack(alignment: .leading) {
            Text("Help Center")
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.leading, 4)
            CardView {
                VStack(spacing: 0) {
                    ForEach(Array(helpCenterMenuItems.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Image(systemName: item.icon)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.secondary)
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.system(size: 18, weight: .medium))
                                Text(item.description)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.gray)
                        }.padding()
                        if index < helpCenterMenuItems.count - 1 {
                            Divider()
                                .padding(.leading, 60)
                        }
                    }
                }
            }
        }
        
    }
    
    private var communitySection: some View {
        VStack(alignment: .leading) {
            Text("Community")
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.leading, 4)
            CardView {
                VStack(spacing: 0) {
                    ForEach(Array(communityMenuItems.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Image(systemName: item.icon)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.secondary)
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.system(size: 18, weight: .medium))
                                Text(item.description)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.gray)
                        }.padding()
                        if index < communityMenuItems.count - 1 {
                            Divider()
                                .padding(.leading, 60)
                        }
                    }
                }
            }
        }
    }
    
    private var header: some View {
        Text("Help & Support")
            .font(.system(size: 28, weight: .bold, design: .rounded))
        
    }
}

#Preview {
    NavigationStack {
        HelpAndSupportView()
    }
}

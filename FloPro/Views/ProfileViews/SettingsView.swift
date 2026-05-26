//
//  SettingsView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 25/05/26.
//

import SwiftUI

struct SettingsView: View {
    
    private let generalSettingsMenuItems: [GeneralSettingItemStruct] = GeneralSettingItem.allCases.map { item in
            .init(type: item)
    }
    
    @State private var privacySettingsMenuItems: [PrivacySettingItemStruct] =
        PrivacySettingItem.allCases.map { item in
            .init(type: item)
    }
    
    var body: some View {
        BackdropContainer {
            VStack(alignment: .leading, spacing: 30) {
                generalSettingsSection
                privacySettingsSection
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
    
    private var generalSettingsSection: some View {
        VStack(alignment: .leading) {
            Text("General")
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.leading, 4)
            CardView {
                VStack(spacing: 0) {
                    ForEach(Array(generalSettingsMenuItems.enumerated()), id: \.offset) { index, item in
                        HStack(spacing: 16) {
                            Text(item.title)
                                .font(.system(size: 18, weight: .medium))
                            Spacer()
                            Text(item.currentValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                                .font(.system(size: 18, weight: .medium))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.gray)
                            
                        }.padding()
                        if index < generalSettingsMenuItems.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    private var privacySettingsSection: some View {
        VStack(alignment: .leading) {
            Text("Privacy")
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.leading, 4)
            CardView {
                VStack(spacing: 0) {
                    ForEach($privacySettingsMenuItems.enumerated(), id: \.element.id) { index, $item in
                        HStack(spacing: 16) {
                            Text(item.title)
                                .font(.system(size: 18, weight: .medium))
                            Spacer()
                            Toggle("", isOn: $item.currentValue)
                                .labelsHidden()
                        }
                        .padding()
                        if index < privacySettingsMenuItems.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    private var header: some View {
        Text("Settings")
            .font(.system(size: 28, weight: .bold, design: .rounded))
        
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

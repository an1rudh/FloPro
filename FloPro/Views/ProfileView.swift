//
//  ProfileView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 04/05/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(UserStore.self) private var userStore
    
    @State private var showResetAlert = false
    @State private var resetMessage: String?
    
    private let profileMenuItems: [ProfileMenuItem] = MenuItem.allCases.map { item in
            .init(menuItem: item)
    }
    
    var body: some View {
        BackdropContainer {
            VStack(spacing: 24) {
                profileHeader
                profileMenu
#if DEBUG
                devTools
#endif
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var profileHeader: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                HStack {
                    Text("\(userStore.userData?.name ?? "")")
                        .font(.title)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                    Spacer()
                }
                HStack {
                    Text("View and edit profile")
                        .foregroundStyle(.secondary)
                        .fontDesign(.rounded)
                    Spacer()
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var profileMenu: some View {
        CardView {
            VStack(spacing: 0) {
                ForEach(Array(profileMenuItems.enumerated()), id: \.element.title) { index, item in
                    NavigationLink {
                        switch item.menuItem {
                        case .reminders: ProfileRemindersView()
                        case .my_data: MyDataView()
                        case .export_data: ExportDataView()
                        case .settings: SettingsView()
                        case .help_support: HelpAndSupportView()
                        case .about: AboutView()
                        }
                        
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: item.icon)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.gray)
                                .frame(width: 24)
                            Text(item.title)
                                .font(.system(size: 18, weight: .medium))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.gray)
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 64)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    if index < profileMenuItems.count - 1 {
                        Divider()
                            .padding(.leading, 60)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var devTools: some View {
        CardView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Developer Tools")
                    .font(.system(size: 18, weight: .semibold))
                    .padding()
                Text("Remove all locally saved onboarding and period tracking data from this device.")
                    .font(.system(size: 14))
                    .padding(.horizontal)
                
                Button(role: .destructive) {
                    showResetAlert = true
                } label: {
                    Text("Clear All Saved Data")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.red.opacity(0.82))
                        )
                }
                .alert("Clear local data?", isPresented: $showResetAlert) {
                    Button("Cancel", role: .cancel) {
                    }
                    Button("Clear", role: .destructive) {
                        clearLocalData()
                    }
                } message: {
                    Text("This removes saved user details and logged period dates from UserDefaults on this device.")
                }
                .buttonStyle(.plain)
                .padding()
                
                
                if let resetMessage {
                    Text(resetMessage)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: 0x625D78))
                }
            }
        }
    }
    
    private func clearLocalData() {
        userStore.clear()
        UserDefaults.standard.removeObject(forKey: "logged_day_records")
        resetMessage = "Local saved data was cleared."
    }
}

#Preview {
    ProfileView()
        .environment(UserStore())
}

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

    private let menuItems: [ProfileMenuItem] = [
        .init(title: "Reminders", icon: "bell"),
        .init(title: "My Data", icon: "chart.bar"),
        .init(title: "Export Data", icon: "square.and.arrow.up"),
        .init(title: "Settings", icon: "gearshape"),
        .init(title: "Help & Support", icon: "questionmark.circle"),
        .init(title: "About FloPro", icon: "info.circle")
    ]

    var body: some View {
        ZStack {
            BackdropView()
            VStack(spacing: 24) {
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
                            Spacer()
                        }
                        HStack {
                            Text("View and edit profile")
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                    .padding()
                }
                CardView {
                    VStack(spacing: 0) {
                        ForEach(Array(menuItems.enumerated()), id: \.element.title) { index, item in
                            Button {
                            } label: {
                                HStack(spacing: 16) {
                                    Image(systemName: item.icon)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(Color(hex: 0x6D6A87))
                                        .frame(width: 24)
                                    Text(item.title)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(Color(hex: 0xA8A5BC))
                                }
                                .padding(.horizontal, 20)
                                .frame(height: 64)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)

                            if index < menuItems.count - 1 {
                                Divider()
                                    .padding(.leading, 60)
                            }
                        }
                    }
                }

                #if DEBUG
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
                        .buttonStyle(.plain)
                        .padding()
                        

                        if let resetMessage {
                            Text(resetMessage)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color(hex: 0x625D78))
                        }
                    }
                }
                #endif
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
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
    }

    private func clearLocalData() {
        userStore.clear()
        UserDefaults.standard.removeObject(forKey: "logged_day_records")
        resetMessage = "Local saved data was cleared."
    }
}

private struct ProfileMenuItem {
    let title: String
    let icon: String
}

#Preview {
    ProfileView()
        .environment(UserStore())
}

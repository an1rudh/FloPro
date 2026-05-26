//
//  ProfileRemindersView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 25/05/26.
//

import SwiftUI

struct ProfileRemindersView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var reminderTypeItems: [ReminderTypeStructure] = [
        .init(type: .period_start),
        .init(type: .fertile_window),
        .init(type: .ovulation),
        .init(type: .log_reminder)
    ]
    
    var body: some View {
        BackdropContainer {
            VStack(alignment: .center, spacing: 30) {
                remindersToggleSection
                remindersSettings
                remindersInfo
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
    
    @ViewBuilder
    private var remindersToggleSection: some View {
        VStack(alignment: .leading) {
            Text("Upcoming Reminders")
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.leading, 4)
            CardView {
                VStack(spacing: 0) {
                    ForEach(reminderTypeItems.indices, id: \.self) { index in
                        HStack(spacing: 16) {
                            VStack(alignment: .leading) {
                                Text(reminderTypeItems[index].title)
                                    .font(.system(size: 18, weight: .medium))
                                Text("1 day before")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Toggle("", isOn: $reminderTypeItems[index].isOn)
                        }
                        .padding()
                        
                        if index < reminderTypeItems.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var remindersSettings: some View {
        VStack(alignment: .leading) {
            Text("Reminder Settings")
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.leading, 4)
            CardView {
                VStack(spacing: 0) {
                    ForEach(Array(ReminderSettings.allCases.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Text(item.title)
                                .font(.system(size: 18, weight: .medium))
                            Spacer()
                            Text(item.data)
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.gray)
                        }.padding()
                        if index < reminderTypeItems.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    private var remindersInfo: some View {
        Text("You'll receive notifications for upcoming events based on your cycle predictions.")
            .font(.system(size: 16, weight: .regular, design: .rounded))
            .foregroundStyle(.secondary)
    }
    
    private var header: some View {
        Text("Reminders")
            .font(.system(size: 28, weight: .bold, design: .rounded))
    }
    
    
}

#Preview {
    NavigationStack {
        ProfileRemindersView()
    }
}

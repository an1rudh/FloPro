//
//  ProfileModel.swift
//  FloPro
//
//  Created by Anirudh Sharma on 25/05/26.
//

enum MenuItem: String, CaseIterable {
    case reminders = "reminders"
    case my_data = "my_data"
    case export_data = "export_data"
    case settings = "settings"
    case help_support = "help_and_support"
    case about = "about"
    var title: String {
        switch self {
        case .reminders: return "Reminders"
        case .my_data: return "My Data"
        case .export_data: return "Export Data"
        case .settings: return "Settings"
        case .help_support: return "Help & Support"
        case .about: return "About"
        }
    }
    var icon: String {
        switch self {
        case .reminders: return "bell"
        case .my_data: return "chart.bar"
        case .export_data: return "square.and.arrow.up"
        case .settings: return "gearshape"
        case .help_support: return "questionmark.circle"
        case .about: return "info.circle"
        }
    }
}

enum ReminderType: String, CaseIterable, Hashable {
    case period_start = "period_start"
    case fertile_window = "fertile_window"
    case ovulation = "ovulation"
    case log_reminder = "log_reminder"
    var title: String {
        switch self {
        case .period_start: return "Period Start"
        case .fertile_window: return "Fertile Window"
        case .ovulation: return "Ovulation"
        case .log_reminder: return "Log Reminder"
        }
    }
}

struct ReminderTypeStructure: Identifiable {
    let type: ReminderType
    let title: String
    var isOn: Bool
    init (type: ReminderType) {
        self.type = type
        self.title = type.title
        self.isOn = true
    }
    var id: ReminderType { type }
}

struct ProfileMenuItem: Identifiable {
    let menuItem: MenuItem
    let title: String
    let icon: String
    init(menuItem: MenuItem) {
        self.menuItem = menuItem
        self.title = menuItem.title
        self.icon = menuItem.icon
    }
    var id: MenuItem { menuItem }
}

enum ReminderSettings: CaseIterable {
    case reminder_time
    case notification_sound
    var title: String {
        switch self {
        case .reminder_time: return "Reminder Time"
        case .notification_sound: return "Notification Sound"
        }
    }
    var data: String {
        switch self {
        case .notification_sound: return "Default"
        case .reminder_time: return "8:00 PM"
        }
    }
}

enum MyDataItem: CaseIterable {
    case cycle_history
    case symptoms
    case mood
    case notes
    case measurements
    var title: String {
        switch self {
        case .cycle_history: return "Cycle History"
        case .symptoms: return "Symptoms"
        case .mood: return "Mood"
        case .notes: return "Notes"
        case .measurements: return "Measurements"
        }
    }
    var description: String {
        switch self {
        case .cycle_history: return "View your past cycles"
        case .symptoms: return "View your logged symptoms"
        case .mood: return "View your mood history"
        case .notes: return "View your personal notes"
        case .measurements: return "View your body measurements"
        }
    }
    var icon: String {
        switch self {
        case .cycle_history: return "calendar"
        case .symptoms: return "stethoscope"
        case .mood: return "face.smiling"
        case .notes: return "note"
        case .measurements: return "ruler"
        }
    }
}

struct MyDataItemStruct: Identifiable {
    let type: MyDataItem
    let title: String
    let description: String
    let icon: String
    init(type: MyDataItem) {
        self.type = type
        self.title = type.title
        self.description = type.description
        self.icon = type.icon
    }
    var id: MyDataItem { type }
}

enum ExportFormat: CaseIterable {
    case json
    case csv
    var title: String {
        switch self {
        case .json: return "JSON"
        case .csv: return "CSV"
        }
    }
    var description: String {
        switch self {
        case .json: return "Best for developers"
        case .csv: return "Best for data analysis"
        }
    }
    var icon: String {
        switch self {
        case .json: return "curlybraces"
        case .csv: return "chart.bar.fill"
        }
    }
}

struct ExportFormatStruct: Identifiable, Equatable {
    let type: ExportFormat
    let title: String
    let description: String
    let icon: String
    init(type: ExportFormat) {
        self.type = type
        self.title = type.title
        self.description = type.description
        self.icon = type.icon
    }
    
    var id: ExportFormat { type }
}

enum IncludeDataItem: CaseIterable, Identifiable {
    case cycleHistory
    case symptoms
    case mood
    case notes
    case measurements
    var title: String {
        switch self {
        case .cycleHistory: return "Cycle history"
        case .symptoms: return "Symptoms"
        case .mood: return "Mood"
        case .notes: return "Notes"
        case .measurements: return "Measurements"
        }
    }
    var id: Self { self }
}

enum GeneralSettingItem: CaseIterable {
    case units
    case start_of_the_week
    case theme
    var title: String {
        switch self {
        case .units: return "Units"
        case .start_of_the_week: return "Start Day of Week"
        case .theme: return "Theme"
        }
    }
    var currentValue: String {
        switch self {
        case .units: return "Metric (cm, kg)"
        case .start_of_the_week: return "Monday"
        case .theme: return "Light"
        }
    }
    
}

struct GeneralSettingItemStruct: Identifiable, Equatable {
    let type: GeneralSettingItem
    let title: String
    let currentValue: String
    init(type: GeneralSettingItem) {
        self.type = type
        self.title = type.title
        self.currentValue = type.currentValue
    }
    var id: GeneralSettingItem { type }
}

enum PrivacySettingItem: CaseIterable {
    case passcode_lock
    case analytics
    var title: String {
        switch self {
        case .passcode_lock: return "Passcode Lock"
        case .analytics: return "Analytics"
        }
    }
    var currentValue: Bool {
        switch self {
        case .passcode_lock: return false
        case .analytics: return true
        }
    }
}

struct PrivacySettingItemStruct: Identifiable, Equatable {
    let type: PrivacySettingItem
    let title: String
    var currentValue: Bool
    init(type: PrivacySettingItem) {
        self.type = type
        self.title = type.title
        self.currentValue = type.currentValue
    }
    
    var id: PrivacySettingItem { type }
}

enum HelpCenterMenuItem: CaseIterable {
    case faq
    case contact_support
    case report_issue
    var title: String {
        switch self {
        case .faq: return "FAQ"
        case .contact_support: return "Contact Support"
        case .report_issue: return "Report An Issue"
        }
    }
    var description: String {
        switch self {
        case .faq: return "Find answers to common questions"
        case .contact_support: return "Get help from our team"
        case .report_issue: return "Let us know what's not working"
        }
    }
    var icon: String {
        switch self {
        case .faq: return "questionmark.circle"
        case .contact_support: return "person.crop.circle"
        case .report_issue: return "exclamationmark.circle"
        }
    }
}

struct HelpCenterMenuItemStruct: Identifiable, Equatable {
    let type: HelpCenterMenuItem
    let title: String
    let description: String
    let icon: String
    init(type: HelpCenterMenuItem) {
        self.type = type
        self.title = type.title
        self.description = type.description
        self.icon = type.icon
    }
    
    var id: HelpCenterMenuItem { type }	
}

enum CommunityMenuItem: CaseIterable {
    case join_community
    case feature_request
    var title: String {
        switch self {
        case .join_community: return "Join Community"
        case .feature_request: return "Feature Request"
        }
    }
    var description: String {
        switch self {
        case .join_community: return "Connect with other users"
        case .feature_request: return "Suggest new features"
        }
    }
    var icon: String {
        switch self {
        case .join_community: return "person.2"
        case .feature_request: return "message.badge.waveform"
        }
    }
}

struct CommunityMenuItemStruct: Identifiable, Equatable {
    let type: CommunityMenuItem
    let title: String
    let description: String
    let icon: String
    init(type: CommunityMenuItem) {
        self.type = type
        self.title = type.title
        self.description = type.description
        self.icon = type.icon
    }
    var id: CommunityMenuItem { type }
}

enum DocumentationItem: CaseIterable {
    case whats_new
    case terms_of_service
    case privacy_policy
    case licenses
    var title: String {
        switch self {
        case .whats_new: return "What's New"
        case .terms_of_service: return "Terms of Service"
        case .privacy_policy: return "Privacy Policy"
        case .licenses: return "Licenses"
        }
    }
    var icon: String {
        switch self {
        case .whats_new: return "info.circle"
        case .terms_of_service: return "doc"
        case .privacy_policy: return "doc"
        case .licenses: return "doc"
        }
    }
}

struct DocumentationItemStruct: Identifiable, Equatable {
    let type: DocumentationItem
    let title: String
    let icon: String
    init(type: DocumentationItem) {
        self.type = type
        self.title = type.title
        self.icon = type.icon
    }
    var id: DocumentationItem { type }
}

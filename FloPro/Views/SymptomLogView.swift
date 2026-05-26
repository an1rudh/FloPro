//
//  PeriodLogView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct SymptomLogView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LogPeriodStore.self) private var logPeriodStore

    @State private var selectedSymptoms: Set<Symptom> = []
    @State private var selectedMood: Mood?
    
    private let logSymptomService: LogSymptomService
    private let date: Date
    private let day: LocalDay
    private let calendar: Calendar
    private let physicalSymptoms: [SymptomItem]  =
    Symptom.allCases.map {
        .init(symptom: $0)
    }
    private let moods: [MoodItem] =
    Mood.allCases.map {
        .init(mood: $0)
    }
    

    init(date: Date = .now, logSymptomService: LogSymptomService = LogSymptomService(), day: LocalDay) {
        self.date = date
        self.logSymptomService = logSymptomService
        self.day = day
        self.calendar = .current
    }

    var body: some View {
        BackdropContainer {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    subHeading
                    symptomSection
                    moodSection
                    saveButton
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                header
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadDraft()
        }
    }

    private var header: some View {
        Text("Symptoms").font(.system(size: 28, weight: .bold, design: .rounded))
    }
    
    private var subHeading: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Log for \(formatted(day: day))")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(hex: 0x625D78))

            Text("Choose all symptoms that match how you feel today.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.secondary)
        }
    }
    
    private func formatted(day: LocalDay) -> String {
        guard let date = day.date(in: calendar) else {
            return "--"
        }
        
        return date.formatted(.dateTime.month(.wide).day().year())
    }

    private var symptomSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Physical")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(hex: 0x3F3955))

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 18), count: 3),
                spacing: 18
            ) {
                ForEach(physicalSymptoms) { item in
                    symptomButton(for: item)
                }
            }
        }
    }

    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Emotional")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(hex: 0x3F3955))

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 18), count: 3),
                spacing: 18
            ) {
                ForEach(moods) { item in
                    moodButton(for: item)
                }
            }
        }
    }

    private func symptomButton(for item: SymptomItem) -> some View {
        let isSelected = selectedSymptoms.contains(item.symptom)

        return Button {
            toggleSelection(for: item)
        } label: {
            logItemLabel(title: item.title, icon: item.icon, tint: item.tint, isSelected: isSelected)
        }
        .buttonStyle(.plain)
    }

    private func moodButton(for item: MoodItem) -> some View {
        let isSelected = selectedMood == item.mood

        return Button {
            toggleSelection(for: item)
        } label: {
            logItemLabel(title: item.title, icon: item.icon, tint: item.tint, isSelected: isSelected)
        }
        .buttonStyle(.plain)
    }

    private func logItemLabel(title: String, icon: String, tint: Color, isSelected: Bool) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(tint.opacity(isSelected ? 0.24 : 0.12))
                    .frame(width: 72, height: 72)
                    .overlay(
                        Circle()
                            .stroke(tint.opacity(isSelected ? 0.6 : 0), lineWidth: 1.5)
                    )

                Image(systemName: icon)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(tint)
            }

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color(hex: 0x4A455F))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }

    private var saveButton: some View {
        Button {
            logPeriodStore.logSymptoms(
                symptoms: selectedSymptoms,
                mood: selectedMood,
                day: day
            )
            dismiss()
        } label: {
            Text("Save")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(isSaveDisabled ? Color.gray.opacity(0.4) : Color(hex: 0xF07DA1))
                )
                .shadow(
                    color: isSaveDisabled ? .clear : Color(hex: 0xF07DA1).opacity(0.25),
                    radius: 16,
                    x: 0,
                    y: 10
                )
        }
        .buttonStyle(.plain)
        .disabled(isSaveDisabled)
        .padding(.top, 4)
    }

    private func toggleSelection(for item: SymptomItem) {
        if selectedSymptoms.contains(item.symptom) {
            selectedSymptoms.remove(item.symptom)
        } else {
            selectedSymptoms.insert(item.symptom)
        }
    }

    private func toggleSelection(for item: MoodItem) {
        selectedMood = selectedMood == item.mood ? nil : item.mood
    }

    private func loadDraft() {
        let record = logPeriodStore.record(for: day)
        selectedSymptoms = record?.symptoms ?? []
        selectedMood = record?.mood
    }
    
    private var isSaveDisabled: Bool {
        let record = logPeriodStore.record(for: day)
        return selectedSymptoms == record?.symptoms ?? []
            && selectedMood == record?.mood
    }
}


#Preview {
    NavigationStack {
        SymptomLogView(day: LocalDay(year: 2016, month: 5, day: 21))
    }
    .environment(LogPeriodStore())
}

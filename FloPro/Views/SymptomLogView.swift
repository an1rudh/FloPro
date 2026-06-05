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
                .padding()
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
        Text("Symptoms").font(AppTypographies.title)
    }
    
    private var subHeading: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Log for \(formatted(day: day))")
                .font(AppTypographies.captionEmphasis)
                .foregroundStyle(AppColors.primaryText)

            Text("Choose all symptoms that match how you feel today.")
                .font(AppTypographies.caption)
                .foregroundStyle(AppColors.secondaryText)
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
                .font(AppTypographies.title2)
                .foregroundStyle(AppColors.primaryText)

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
                .font(AppTypographies.title2)
                .foregroundStyle(AppColors.primaryText)

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
                .font(AppTypographies.button)
                .foregroundStyle(AppColors.primaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
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
                .font(AppTypographies.body)
                .foregroundStyle(AppColors.contrastText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    isSaveDisabled ? AppColors.disabledGradient : AppColors.tertiaryGradient
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: isSaveDisabled ? .clear : .black.opacity(0.04), radius: 16, x: 0, y: 6)
                .shadow(color: isSaveDisabled ? .clear : .white.opacity(0.7), radius: 1, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .disabled(isSaveDisabled)
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

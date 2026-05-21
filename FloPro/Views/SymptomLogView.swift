//
//  PeriodLogView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct SymptomLogView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedSymptoms: Set<Symptom> = []
    @State private var selectedMood: Mood?
    @State private var selectedIntensity: SymptomIntensity = .moderate

    let date: Date
    let logSymptomService: LogSymptomService
    let day: LocalDay

    init(date: Date = .now, logSymptomService: LogSymptomService = LogSymptomService(), day: LocalDay) {
        self.date = date
        self.logSymptomService = logSymptomService
        self.day = day
    }

    var body: some View {
        ZStack {
            BackdropView()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    headerView
                    symptomSection(title: "Physical", items: logSymptomService.physicalSymptoms)
                    moodSection(title: "Emotional", items: logSymptomService.moods)
                    intensitySection
                    saveButton
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                BackButtonView()
                Spacer()

                Text("Symptoms")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x3F3955))

                Spacer()

                Color.clear
                    .frame(width: 36, height: 36)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Log for \(date.formatted(date: .complete, time: .omitted))")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: 0x625D78))

                Text("Choose all symptoms that match how you feel today.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func symptomSection(title: String, items: [SymptomItem]) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(hex: 0x3F3955))

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 18), count: 3),
                spacing: 18
            ) {
                ForEach(items) { item in
                    symptomButton(for: item)
                }
            }
        }
    }

    private func moodSection(title: String, items: [MoodItem]) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(hex: 0x3F3955))

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 18), count: 3),
                spacing: 18
            ) {
                ForEach(items) { item in
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

    private var intensitySection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Intensity")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(hex: 0x3F3955))

            HStack(spacing: 12) {
                ForEach(SymptomIntensity.allCases) { intensity in
                    Button {
                        selectedIntensity = intensity
                    } label: {
                        Text(intensity.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(selectedIntensity == intensity ? .white : Color(hex: 0x5F5973))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(selectedIntensity == intensity ? Color(hex: 0xF07DA1) : Color.white.opacity(0.78))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color(hex: 0xEFE8F0), lineWidth: selectedIntensity == intensity ? 0 : 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var saveButton: some View {
        Button {
            logSymptomService.logSymptoms(
                symptoms: selectedSymptoms,
                mood: selectedMood,
                intensity: selectedIntensity,
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
                        .fill(Color(hex: 0xF07DA1))
                )
                .shadow(color: Color(hex: 0xF07DA1).opacity(0.25), radius: 16, x: 0, y: 10)
        }
        .buttonStyle(.plain)
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
}


#Preview {
    NavigationStack {
        SymptomLogView(day: LocalDay(year: 2016, month: 5, day: 21))
    }
}

//
//  PeriodLogView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct SymptomLogView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedSymptoms: Set<String> = []
    @State private var selectedIntensity: SymptomIntensity = .moderate

    let date: Date
    let onSave: (SymptomLogEntry) -> Void

    private let physicalSymptoms: [SymptomItem] = [
        .init(title: "Cramps", icon: "bolt.fill", tint: Color(hex: 0xF59D62)),
        .init(title: "Headache", icon: "brain.head.profile", tint: Color(hex: 0x9581F2)),
        .init(title: "Bloating", icon: "drop.fill", tint: Color(hex: 0xEF7D85)),
        .init(title: "Acne", icon: "circle.grid.2x2.fill", tint: Color(hex: 0xF38A6A)),
        .init(title: "Fatigue", icon: "sun.max.fill", tint: Color(hex: 0xF4B955)),
        .init(title: "Backache", icon: "figure.walk", tint: Color(hex: 0x8F79F1))
    ]

    private let emotionalSymptoms: [SymptomItem] = [
        .init(title: "Happy", icon: "face.smiling.fill", tint: Color(hex: 0x8A74F1)),
        .init(title: "Sad", icon: "cloud.drizzle.fill", tint: Color(hex: 0x7C96F6)),
        .init(title: "Irritated", icon: "flame.fill", tint: Color(hex: 0xF58AA8)),
        .init(title: "Anxious", icon: "exclamationmark.circle.fill", tint: Color(hex: 0xF78BAB)),
        .init(title: "Calm", icon: "leaf.fill", tint: Color(hex: 0xF3B85A)),
        .init(title: "Excited", icon: "sparkles", tint: Color(hex: 0xF39A44))
    ]

    init(date: Date = .now, onSave: @escaping (SymptomLogEntry) -> Void = { _ in }) {
        self.date = date
        self.onSave = onSave
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: 0xFFF9FB),
                    Color(hex: 0xFFF3F8),
                    Color(hex: 0xFFF8FE)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    headerView
                    symptomSection(title: "Physical", items: physicalSymptoms)
                    symptomSection(title: "Emotional", items: emotionalSymptoms)
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
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(hex: 0x44405B))
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.8), in: Circle())
                }
                .buttonStyle(.plain)

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

    private func symptomButton(for item: SymptomItem) -> some View {
        let isSelected = selectedSymptoms.contains(item.title)

        return Button {
            toggleSelection(for: item)
        } label: {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(item.tint.opacity(isSelected ? 0.24 : 0.12))
                        .frame(width: 72, height: 72)
                        .overlay(
                            Circle()
                                .stroke(item.tint.opacity(isSelected ? 0.6 : 0), lineWidth: 1.5)
                        )

                    Image(systemName: item.icon)
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(item.tint)
                }

                Text(item.title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color(hex: 0x4A455F))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
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
            onSave(
                SymptomLogEntry(
                    date: date,
                    symptoms: selectedSymptoms.sorted(),
                    intensity: selectedIntensity
                )
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
        if selectedSymptoms.contains(item.title) {
            selectedSymptoms.remove(item.title)
        } else {
            selectedSymptoms.insert(item.title)
        }
    }
}

private struct SymptomItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let tint: Color
}

struct SymptomLogEntry {
    let date: Date
    let symptoms: [String]
    let intensity: SymptomIntensity
}

enum SymptomIntensity: CaseIterable, Identifiable {
    case mild
    case moderate
    case severe

    var id: Self { self }

    var title: String {
        switch self {
        case .mild:
            return "Mild"
        case .moderate:
            return "Moderate"
        case .severe:
            return "Severe"
        }
    }
}

#Preview {
    NavigationStack {
        SymptomLogView()
    }
}

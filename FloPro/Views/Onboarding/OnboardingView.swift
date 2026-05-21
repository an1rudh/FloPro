//
//  OnboardingView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 27/04/26.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(UserStore.self) private var userStore

    @State private var name = ""
    @State private var selectedAge = 24
    @State private var selectedCycleLength = 28
    @State private var selectedPeriodLength = 5
    @State private var selectedGoal: UserData.UserGoal = .trackCycle

    private let ageOptions = Array(18...50)
    private let cycleLengthOptions = Array(21...40)
    private let periodLengthOptions = Array(2...10)

    var body: some View {
        ZStack {
            BackdropView()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    headerSection
                    nameSection
                    selectionSection
                    goalSection
                    continueButton
                }
                .padding(.horizontal, 28)
                .padding(.top, 52)
                .padding(.bottom, 24)
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Let's get to know you")
                .font(.system(size: 34, weight: .bold))

            Text("This helps us personalize your experience")
                .font(.system(size: 16, weight: .medium))
        }
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Name")
                .font(.system(size: 15, weight: .semibold))
                .padding(.leading, 6)

            CardView {
                TextField("Enter your name", text: $name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding()
            }
        }
    }

    private var selectionSection: some View {
        VStack(spacing: 20) {
            onboardingPicker(
                title: "Age",
                selection: $selectedAge,
                options: ageOptions,
                valueLabel: { "\($0)" }
            )

            onboardingPicker(
                title: "Average cycle length",
                selection: $selectedCycleLength,
                options: cycleLengthOptions,
                valueLabel: { "\($0) days" }
            )

            onboardingPicker(
                title: "Average period length",
                selection: $selectedPeriodLength,
                options: periodLengthOptions,
                valueLabel: { "\($0) days" }
            )
        }
    }

    private var goalSection: some View {
        VStack(alignment: .leading) {
            Text("What's your goal?")
                .font(.system(size: 20, weight: .semibold))
            VStack(spacing: 12) {
                ForEach(UserData.UserGoal.allCases, id: \.self) { goal in
                    Button {
                        selectedGoal = goal
                    } label: {
                        HStack {
                            Text(goal.title)
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            ZStack {
                                Circle()
                                    .stroke(
                                        selectedGoal == goal ? Color(hex: 0xFF5D95) : Color(hex: 0xD9DCE7),
                                        lineWidth: 2
                                    )
                                    .frame(width: 24, height: 24)

                                if selectedGoal == goal {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(goalBackground(for: goal))
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var continueButton: some View {
        Button(action: saveUserData) {
            Text("Continue")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    Color(hex: 0xFF4F87)
                )
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: Color(hex: 0xFF6A9A, opacity: 0.26), radius: 18, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }

    private func onboardingPicker(
        title: String,
        selection: Binding<Int>,
        options: [Int],
        valueLabel: @escaping (Int) -> String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .padding(.leading, 6)
            CardView {
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(valueLabel(option)) {
                            selection.wrappedValue = option
                        }
                    }
                } label: {
                    HStack {
                        Text(valueLabel(selection.wrappedValue))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(.black)

                        Spacer()

                        Image(systemName: "chevron.down")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color(hex: 0x69708A))
                    }.padding()
                }
            }
        }
    }

    private func goalBackground(for goal: UserData.UserGoal) -> AnyShapeStyle {
        if selectedGoal == goal {
            return AnyShapeStyle(Color(hex: 0xFFD7E4))
        } else {
            return AnyShapeStyle(Color.white.opacity(0.96))
        }
    }

    private func saveUserData() {
        let userData = UserData(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            cylceLength: selectedCycleLength,
            periodLength: selectedPeriodLength,
            age: selectedAge,
            userGoal: selectedGoal,
            isUserOnboarded: true
        )
        userStore.save(userData)
    }
}

#Preview {
    OnboardingView()
        .environment(UserStore())
}

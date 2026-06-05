//
//  AppColors.swift
//  FloPro
//
//  Created by Anirudh Sharma on 28/05/26.
//

// FloPro/FloPro/Design/AppColors.swift
import SwiftUI

enum AppColors {
    static let primaryBackground = Color(hex: 0xf2f2f7)
    static let secondaryBackground = Color(hex: 0xeeeef0)
    static let cardBackground = Color(hex: 0xFFFFFF)
    
    static let primaryText = Color(hex: 0x161925)
    static let secondaryText = Color(hex: 0x6B7285)
    static let tertiaryText = Color(hex: 0x8B6CFF)
    static let contrastText = Color(hex: 0xFFFFFF)
    
    static let accent = Color(hex: 0x8B6CFF)
    static let border = Color(hex: 0xe7e7e8)
    
    
    static let primaryPurple = Color(hex: 0x7B61FF)
    static let brightPurple = Color(hex: 0xA98BFF)
    static let indigoGlow = Color(hex: 0x6D7CFF)
    
    static let primaryGradient = LinearGradient(
        colors: [
            Color(hex: 0x9B8CFF),
            Color(hex: 0x7B61FF),
            Color(hex: 0x5B3DF5)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let secondaryGradient = LinearGradient(
        colors: [
            Color(hex: 0x7B61FF),
            Color(hex: 0x4D8DFF)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let tertiaryGradient = LinearGradient(
        colors: [
            Color(hex: 0x8B73FF),
            Color(hex: 0x6A4DFF)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let disabledGradient = LinearGradient(
        colors: [Color.gray.opacity(0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

//    static let period = Color("PeriodColor")
//    static let fertile = Color("FertileColor")
//    static let ovulation = Color("OvulationColor")

    static let success = Color(hex: 0x48C774)
    static let warning = Color(hex: 0xFFB020)
    static let danger = Color(hex: 0xFF5C5C)
}

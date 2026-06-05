//
//  AppTypographies.swift
//  FloPro
//
//  Created by Anirudh Sharma on 28/05/26.
//

import SwiftUI

enum AppTypographies {
    static let extraLargeTitle = Font.system(size: 66, weight: .bold, design: .rounded)
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)

    static let body = Font.system(size: 18, weight: .regular, design: .default)
    static let bodyEmphasis = Font.system(size: 18, weight: .semibold, design: .default)

    static let caption = Font.system(size: 14, weight: .regular, design: .default)
    static let captionEmphasis = Font.system(size: 14, weight: .semibold, design: .default)

    static let button = Font.system(size: 16, weight: .semibold, design: .rounded)
}

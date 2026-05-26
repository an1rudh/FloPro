//
//  SwipeBack.swift
//  FloPro
//
//  Created by Anirudh Sharma on 26/05/26.
//

import SwiftUI

extension View {
    func enableSwipeBack() -> some View {
        self.background(SwipeBackController())
    }
}

struct SwipeBackController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Find the Navigation Controller in the view hierarchy
        DispatchQueue.main.async {
            guard let navigationController = uiViewController.navigationController else { return }
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            navigationController.interactivePopGestureRecognizer?.delegate = navigationController as? any UIGestureRecognizerDelegate
        }
    }
}

//
//  AboutView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 25/05/26.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        BackdropContainer {
            VStack(alignment: .leading, spacing: 30) {
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                header
            }
        }
    }
    
    private var header: some View {
        Text("About FloPro")
            .font(.system(size: 28, weight: .bold, design: .rounded))
        
    }

}

#Preview {
    NavigationStack {
        AboutView()
    }
}

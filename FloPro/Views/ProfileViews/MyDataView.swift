//
//  MyDataView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 25/05/26.
//

import SwiftUI

struct MyDataView: View {
    private let myDataMenuItems: [MyDataItemStruct] = MyDataItem.allCases.map { item in
            .init(type: item)
    }
    
    var body: some View {
        BackdropContainer {
            VStack(alignment: .leading, spacing: 30) {
                myDataMenu
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                header
            }
        }
    }
    
    private var myDataMenu: some View {
        CardView {
            VStack(spacing: 0) {
                ForEach(Array(myDataMenuItems.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Image(systemName: item.icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.secondary)
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.system(size: 18, weight: .medium))
                            Text(item.description)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)
                    }.padding()
                    if index < myDataMenuItems.count - 1 {
                        Divider()
                            .padding(.leading, 60)
                    }
                }
            }
        }
        
    }
    
    private var header: some View {
        Text("My Data")
            .font(.system(size: 28, weight: .bold, design: .rounded))
        
    }
}

#Preview {
    NavigationStack {
        MyDataView()
    }
}

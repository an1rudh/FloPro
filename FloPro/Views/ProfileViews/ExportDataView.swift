//
//  ExportDataView.swift
//  FloPro
//
//  Created by Anirudh Sharma on 25/05/26.
//

import SwiftUI

struct ExportDataView: View {
    
    @State private var selectedFormat: ExportFormatStruct = .init(type: .csv)
    private let exportFormatMenu: [ExportFormatStruct] = ExportFormat.allCases.map{
        item in
            .init(type: item)
    }
    private let selectedIncludeData: Set<IncludeDataItem> = Set(
        IncludeDataItem.allCases.map { item in
            item
        }
    )
    
    var body: some View {
        BackdropContainer {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    description
                    exportFormatSection
                    includeDataSection
                    exportButton
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                header
            }
        }
    }
    
    private var description: some View {
        Text("Export data to a file that you can save or share.")
            .font(.system(size: 16, weight: .regular, design: .rounded))
            .foregroundStyle(.secondary)
    }
    
    private var exportFormatSection: some View {
        VStack(alignment: .leading) {
            Text("Export Format")
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.leading, 4)
            CardView {
                VStack(spacing: 0) {
                    ForEach(Array(exportFormatMenu.enumerated()), id: \.element.id) { index, item in
                        Button {
                            selectedFormat = item
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: item.icon)
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(.secondary)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.system(size: 18, weight: .medium))
                                    
                                    Text(item.description)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName:
                                        selectedFormat == item
                                      ? "largecircle.fill.circle"
                                      : "circle"
                                )
                                .font(.system(size: 22))
                                .foregroundStyle(
                                    selectedFormat == item
                                    ? .blue
                                    : .gray.opacity(0.6)
                                )
                            }
                            .padding()
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        if index < exportFormatMenu.count - 1 {
                            Divider()
                                .padding(.leading, 60)
                        }
                    }
                }
            }
        }
    }
    
    private var includeDataSection: some View {
        VStack(alignment: .leading) {
            Text("Include Data")
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.leading, 4)
            CardView {
                VStack(spacing: 0) {
                    ForEach(Array(IncludeDataItem.allCases.enumerated()), id: \.offset) { index, item in
                        HStack(spacing: 16) {
                            Text(item.title)
                                .font(.system(size: 18, weight: .medium))
                            Spacer()
                            Image(systemName:
                                    selectedIncludeData.contains(item)
                                  ? "checkmark.square.fill"
                                  : "square"
                            )
                            .font(.system(size: 22))
                            .foregroundStyle(
                                selectedIncludeData.contains(item)
                                ? .blue
                                : .gray.opacity(0.7)
                            )
                        }.padding()
                        if index < exportFormatMenu.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    private var header: some View {
        Text("Export Data")
            .font(.system(size: 28, weight: .bold, design: .rounded))
    }
    
    private var exportButton: some View {
        Button {
            
        } label: {
            Text("Export")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(hex: 0xF07DA1))
                )
                .shadow(
                    color: Color(hex: 0xF07DA1).opacity(0.25),
                    radius: 16,
                    x: 0,
                    y: 10
                )
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }
}

#Preview {
    NavigationStack {
        ExportDataView()
    }
}

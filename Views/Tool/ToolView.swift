//
//  ToolView.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import SwiftUI

struct ToolView: View {

    let tool: NetworkTool

    @State private var viewModel = ToolViewModel()

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: AppSpacing.large) {

                Text(tool.title)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)

                TextField(tool.placeholder, text: $viewModel.input)
                    .padding()
                    .background(AppColors.card)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                if tool.showsDNSRecordPicker {

                    DNSRecordPicker(selectedRecord: $viewModel.selectedRecord)
                }

                PrimaryButton(
                    title: tool == .dns ? "Lookup" : "Start"
                ) {
                    viewModel.execute(tool: tool)
                }

                ResultCard(text: viewModel.result)

            }
            .padding()

        }
        .background(AppColors.background)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {

    NavigationStack {

        ToolView(tool: .dns)
    }
}

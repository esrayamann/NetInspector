//
//  ToolCard.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import SwiftUI

struct ToolCard: View {

    let tool: NetworkTool

    var body: some View {

        VStack(spacing: AppSpacing.medium) {

            Image(systemName: tool.icon)
                .font(.system(size: 34))
                .foregroundStyle(.blue)

            Text(tool.title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ToolCard(tool: .ping)
        .padding()
        .background(AppColors.background)
}

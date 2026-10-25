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

        VStack(alignment: .leading, spacing: AppSpacing.medium) {

            Image(systemName: tool.icon)
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(AppColors.primary)
                .frame(width: 48, height: 48)
                .background(AppColors.primary.opacity(0.13))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            Text(tool.title)
                .font(.headline)
                .foregroundStyle(.white)

            Text(tool.summary)
                .font(.caption)
                .foregroundStyle(AppColors.secondaryText)
                .lineLimit(2)

            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 184, alignment: .leading)
        .background(AppColors.card)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.07), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ToolCard(tool: .ping)
        .padding()
        .background(AppColors.background)
}

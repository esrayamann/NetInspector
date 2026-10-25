//
//  PrimaryButton.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import SwiftUI

struct PrimaryButton: View {

    let title: String
    var isLoading = false
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }

                Text(title)
                    .font(.headline)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

#Preview {
    PrimaryButton(title: "Start") {
        
    }
    .padding()
}

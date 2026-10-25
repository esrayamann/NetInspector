//
//  ResultCard.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import SwiftUI

struct ResultCard: View {

    let text: String

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Result")
                .font(.headline)
                .foregroundStyle(.white)

            Divider()

            Text(text)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.white)
                .textSelection(.enabled)

        }
        .padding()
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    ResultCard(text: "Henüz sorgu yapılmadı.")
        .padding()
}

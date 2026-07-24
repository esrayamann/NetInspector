//
//  DNSResultCard.swift
//  NetInspector
//
//  Created by Esra Yaman on 23.07.2026.
//

import SwiftUI

struct DNSResultCard: View {

    let result: DNSLookupResult

    var body: some View {

        VStack(alignment: .leading, spacing: 18) {

            HStack {

                Image(systemName: "globe")
                    .font(.title2)
                    .foregroundStyle(.blue)

                VStack(alignment: .leading) {

                    Text("DNS Lookup")
                        .font(.headline)

                    Text(result.recordType.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                }

                Spacer()
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {

                Text("Domain")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(result.domain)

            }

            Divider()

            Text("Records")
                .font(.headline)

            ForEach(result.records, id: \.self) { record in

                HStack {

                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(.blue)

                    Text(record)

                }
                .padding(.vertical, 4)

            }

        }
        .padding()
        .background(AppColors.card)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.08))
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))

    }

}

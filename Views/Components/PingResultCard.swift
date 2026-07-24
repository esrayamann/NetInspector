//
//  PingResultCard.swift
//  NetInspector
//
//  Created by Esra Yaman on 23.07.2026.
//

import SwiftUI

struct PingResultCard: View {

    let host: String
    let ip: String
    let replies: [Double]

    var minimum: Double {
        replies.min() ?? 0
    }

    var maximum: Double {
        replies.max() ?? 0
    }

    var average: Double {
        guard !replies.isEmpty else { return 0 }
        return replies.reduce(0, +) / Double(replies.count)
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 18) {

            // Header
            HStack {

                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.title2)
                    .foregroundStyle(.green)

                VStack(alignment: .leading) {

                    Text("Ping Successful")
                        .font(.headline)

                    Text("TCP Ping")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                }

                Spacer()
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {

                Text("Host")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(host)

                Text("IP Address")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)

                Text(ip)

            }

            Divider()

            Text("Replies")
                .font(.headline)

            ForEach(Array(replies.enumerated()), id: \.offset) { index, value in

                HStack {

                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)

                    Text("#\(index + 1)")
                        .frame(width: 35, alignment: .leading)

                    Spacer()

                    Text(String(format: "%.1f ms", value))
                        .fontWeight(.medium)

                }
                .padding(.vertical, 4)

            }

            Divider()

            VStack(spacing: 10) {

                statisticRow(
                    title: "Minimum",
                    value: minimum
                )

                statisticRow(
                    title: "Average",
                    value: average
                )

                statisticRow(
                    title: "Maximum",
                    value: maximum
                )

            }

        }
        .padding()
        .background(AppColors.card)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))

    }

    @ViewBuilder
    private func statisticRow(
        title: String,
        value: Double
    ) -> some View {

        HStack {

            Text(title)

            Spacer()

            Text(String(format: "%.1f ms", value))
                .fontWeight(.semibold)

        }

    }

}

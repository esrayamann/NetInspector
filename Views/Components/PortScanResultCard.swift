import SwiftUI

struct PortScanResultCard: View {

    let results: [PortScanResult]
    let duration: Double

    var body: some View {

        VStack(alignment: .leading, spacing: 18) {

            // Header
            HStack {

                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.green)

                VStack(alignment: .leading) {

                    Text("Scan Completed")
                        .font(.headline)

                    Text("TCP Port Scan")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                }

                Spacer()
            }

            Divider()

            // Statistics
            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text("Duration")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(String(format: "%.2f sec", duration))
                        .font(.headline)

                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {

                    Text("Open Ports")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(results.count)")
                        .font(.headline)

                }

            }

            Divider()

            Text("Detected Services")
                .font(.headline)

            ForEach(results) { result in

                HStack {

                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)

                    Text("\(result.port)")
                        .fontWeight(.semibold)
                        .frame(width: 50, alignment: .leading)

                    Text(result.service)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)

                }
                .padding(.vertical, 6)

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
}

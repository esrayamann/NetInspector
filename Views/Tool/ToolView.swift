//
//  ToolView.swift
//  NetInspector
//

import SwiftUI

struct ToolView: View {

    let tool: NetworkTool

    @FocusState private var isInputFocused: Bool
    @State private var viewModel = ToolViewModel()

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text(tool.title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.white)

                        Text(tool.summary)
                            .foregroundStyle(AppColors.secondaryText)
                    }

                    inputField(
                        placeholder: tool.placeholder,
                        text: $viewModel.input,
                        numeric: tool.prefersNumericKeyboard
                    )
                    .onChange(of: viewModel.input) {
                        if tool.shouldForceLowercase {
                            viewModel.input = viewModel.input.lowercased()
                        }
                    }

                    if tool.requiresSubnetMask {
                        inputField(
                            placeholder: "Subnet mask (for example, 255.255.255.0)",
                            text: $viewModel.subnetMask,
                            numeric: true
                        )
                    }

                    if tool.showsDNSRecordPicker {
                        DNSRecordPicker(selectedRecord: $viewModel.selectedRecord)
                    }

                    if tool.requiresPortRange {
                        HStack(spacing: AppSpacing.medium) {
                            inputField(placeholder: "Start port", text: $viewModel.startPort, numeric: true)
                            inputField(placeholder: "End port", text: $viewModel.endPort, numeric: true)
                        }

                        Text("For a responsive, responsible scan, ranges are limited to \(ToolViewModel.maximumPortRange) ports.")
                            .font(.caption)
                            .foregroundStyle(AppColors.secondaryText)
                    }

                    PrimaryButton(
                        title: actionTitle,
                        isLoading: viewModel.isWorking,
                        action: runTool
                    )
                    .disabled(viewModel.isWorking)

                    if viewModel.isWorking {
                        progressCard
                    }

                    resultView
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var actionTitle: String {
        if viewModel.isScanning { return "Scanning ports…" }
        if viewModel.isPinging { return "Measuring latency…" }
        if viewModel.isLookingUpDNS { return "Looking up records…" }
        if tool == .dns { return "Look up DNS" }
        if tool == .ipCalculator { return "Calculate subnet" }
        return "Start \(tool.title)"
    }

    @ViewBuilder
    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ProgressView()
                Text(tool == .portScan ? "Checking TCP ports…" : "Working…")
                    .foregroundStyle(.secondary)
            }

            if tool == .portScan {
                ProgressView(value: viewModel.progress)

                HStack {
                    Text("\(Int(viewModel.progress * 100))%")
                        .font(.headline)

                    Spacer()

                    Text("\(viewModel.scannedPorts) / \(viewModel.totalPorts)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private var resultView: some View {
        if tool == .portScan, !viewModel.scanResults.isEmpty {
            PortScanResultCard(
                results: viewModel.scanResults,
                duration: viewModel.scanDuration
            )
        } else if tool == .ping, !viewModel.pingReplies.isEmpty {
            PingResultCard(
                host: viewModel.pingHost,
                ip: viewModel.pingIP,
                replies: viewModel.pingReplies
            )
        } else if tool == .dns, let dns = viewModel.dnsResult {
            DNSResultCard(result: dns)
        } else {
            ResultCard(text: viewModel.result)
        }
    }

    private func inputField(
        placeholder: String,
        text: Binding<String>,
        numeric: Bool
    ) -> some View {
        TextField(placeholder, text: text)
            .focused($isInputFocused)
            .keyboardType(numeric ? .numbersAndPunctuation : .URL)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.go)
            .onSubmit(runTool)
            .padding()
            .foregroundStyle(.white)
            .background(AppColors.card)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(isInputFocused ? 0.22 : 0.07), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func runTool() {
        guard !viewModel.isWorking else { return }

        isInputFocused = false

        Task { await viewModel.execute(tool: tool) }
    }
}

#Preview {
    NavigationStack {
        ToolView(tool: .dns)
    }
}

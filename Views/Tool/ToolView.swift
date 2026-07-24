//
//  ToolView.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import SwiftUI

struct ToolView: View {

    let tool: NetworkTool

    @FocusState private var isInputFocused: Bool
    @State private var viewModel = ToolViewModel()

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: AppSpacing.large) {

                Text(tool.title)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)

                TextField(tool.placeholder, text: $viewModel.input)
                    .focused($isInputFocused)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.input) {
                        if tool.shouldForceLowercase {
                            viewModel.input = viewModel.input.lowercased()
                        }
                    }
                
                if tool.requiresSubnetMask {

                    TextField("Subnet Mask", text: $viewModel.subnetMask)
                        .focused($isInputFocused)
                        .padding()
                        .background(AppColors.card)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                if tool.showsDNSRecordPicker {

                    DNSRecordPicker(selectedRecord: $viewModel.selectedRecord)
                }
                
                if tool.requiresPortRange {

                    TextField("Start Port", text: $viewModel.startPort)
                        .focused($isInputFocused)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(AppColors.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    TextField("End Port", text: $viewModel.endPort)
                        .focused($isInputFocused)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(AppColors.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                PrimaryButton(
                    title:
                        tool == .portScan && viewModel.isScanning ? "Scanning..." :
                        tool == .ping && viewModel.isPinging ? "Pinging..." :
                        tool == .dns ? "Lookup" :
                        "Start"
                ) {

                    guard !viewModel.isScanning else { return }

                    isInputFocused = false

                    Task {
                        await viewModel.execute(tool: tool)
                    }

                }
                .disabled(viewModel.isScanning || viewModel.isPinging)
                
                if tool == .portScan && viewModel.isScanning {

                    VStack(alignment: .leading, spacing: 12) {

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
                    .padding()
                    .background(AppColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                }
                
                if tool == .ping && viewModel.isPinging {

                    HStack(spacing: 12) {

                        ProgressView()

                        Text("Measuring latency...")
                            .foregroundStyle(.secondary)

                    }
                    .padding()
                    .background(AppColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                }
                
                if tool == .portScan {

                    if viewModel.scanResults.isEmpty {

                        ResultCard(text: viewModel.result)

                    } else {

                        PortScanResultCard(
                            results: viewModel.scanResults,
                            duration: viewModel.scanDuration
                        )

                    }

                } else if tool == .ping {

                    if viewModel.pingReplies.isEmpty {

                        ResultCard(text: viewModel.result)

                    } else {

                        PingResultCard(
                            host: viewModel.pingHost,
                            ip: viewModel.pingIP,
                            replies: viewModel.pingReplies
                        )

                    }

                } else if tool == .dns {
                    
                    if let dns = viewModel.dnsResult {

                        DNSResultCard(result: dns)

                    } else {

                        ResultCard(text: viewModel.result)

                    }

                } else {

                    ResultCard(text: viewModel.result)

                }

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

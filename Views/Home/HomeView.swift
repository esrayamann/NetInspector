//
//  HomeView.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import SwiftUI


struct HomeView: View {

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.medium),
        GridItem(.flexible(), spacing: AppSpacing.medium)
    ]

    var body: some View {

        NavigationStack {

            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                ScrollView {

                    VStack(alignment: .leading, spacing: AppSpacing.large) {

                        HStack(alignment: .top, spacing: AppSpacing.medium) {
                            VStack(alignment: .leading, spacing: 6) {

                                Text("NetInspector")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundStyle(.white)

                                Text("Practical network checks, kept simple.")
                                    .foregroundStyle(AppColors.secondaryText)
                            }

                            Spacer()

                            Image(systemName: "network")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(AppColors.primary)
                                .padding(12)
                                .background(AppColors.card)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }

                        LazyVGrid(columns: columns, spacing: AppSpacing.medium) {

                            ForEach(NetworkTool.availableTools) { tool in

                                NavigationLink {

                                    ToolView(tool: tool)

                                } label: {

                                    ToolCard(tool: tool)
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Label("Use only on hosts and networks you are authorized to inspect.", systemImage: "checkmark.shield")
                                .font(.caption)
                                .foregroundStyle(AppColors.secondaryText)

                            Text("Version 1.1")
                                .font(.caption2)
                                .foregroundStyle(AppColors.secondaryText)
                        }
                        .padding(.top, AppSpacing.small)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}

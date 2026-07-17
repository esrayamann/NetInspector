//
//  HomeView.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import SwiftUI


struct HomeView: View {

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: AppSpacing.large) {

                    VStack(alignment: .leading, spacing: 6) {

                        Text("NetInspector")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.white)

                        Text("Professional Network Utility")
                            .foregroundStyle(.gray)
                    }

                    LazyVGrid(columns: columns, spacing: AppSpacing.medium) {

                        ForEach(NetworkTool.allCases) { tool in

                            NavigationLink {

                                ToolView(tool: tool)
                                    .font(.largeTitle)
                                        .bold()
                                .foregroundStyle(.white)

                            } label: {

                                ToolCard(tool: tool)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Spacer(minLength: 20)

                    Text("Version 1.0")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}

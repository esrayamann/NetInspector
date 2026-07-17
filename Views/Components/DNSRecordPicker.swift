//
//  DNSRecordPicker.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import SwiftUI

struct DNSRecordPicker: View {

    @Binding var selectedRecord: DNSRecordType

    var body: some View {

        HStack(spacing: 12) {

            ForEach(DNSRecordType.allCases) { record in

                Button {

                    selectedRecord = record

                } label: {

                    Text(record.rawValue)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical,10)
                        .background(
                            selectedRecord == record
                            ? AppColors.primary
                            : AppColors.card
                        )
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
        }
    }
}

#Preview {

    DNSRecordPicker(selectedRecord: .constant(.a))
        .padding()
}

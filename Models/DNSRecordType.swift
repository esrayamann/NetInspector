//
//  DNSRecordType.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import Foundation

enum DNSRecordType: String, CaseIterable, Identifiable {

    case a = "A"
    case mx = "MX"
    case txt = "TXT"

    var id: String { rawValue }
    
    var description: String {
            switch self {
            case .a:
                return "IPv4 Address"

            case .mx:
                return "Mail Server"

            case .txt:
                return "Text Record"
            }
        }
    
    var queryValue: Int {

            switch self {

            case .a:
                return 1

            case .mx:
                return 15

            case .txt:
                return 16

            }

        }
}

//
//  NetworkTool.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import Foundation

enum NetworkTool: String, CaseIterable, Identifiable {

    case ping
    case dns
    case whois
    case traceroute
    case portScan
    case ipCalculator

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ping:
            return "Ping"

        case .dns:
            return "DNS Lookup"

        case .whois:
            return "WHOIS"

        case .traceroute:
            return "Traceroute"

        case .portScan:
            return "Port Scanner"

        case .ipCalculator:
            return "IP Calculator"
        }
    }

    var icon: String {
        switch self {

        case .ping:
            return AppIcons.ping

        case .dns:
            return AppIcons.dns

        case .whois:
            return AppIcons.whois

        case .traceroute:
            return AppIcons.traceroute

        case .portScan:
            return AppIcons.port

        case .ipCalculator:
            return AppIcons.calculator
        }
    }
    
    var placeholder: String {
        switch self {
        case .ping:
            return "Enter IP address or hostname"

        case .dns:
            return "Enter domain"

        case .whois:
            return "Enter domain"

        case .traceroute:
            return "Enter IP address or hostname"

        case .portScan:
            return "Enter IP address"

        case .ipCalculator:
            return "Enter IP address"
        }
    }
    
    var showsDNSRecordPicker: Bool {
        self == .dns
    }
}

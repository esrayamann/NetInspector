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

    /// Only tools with a complete, on-device workflow are shown in the app.
    /// Traceroute remains in the model so it can be enabled when implemented.
    static var availableTools: [NetworkTool] {
        allCases.filter(\.isAvailable)
    }

    var isAvailable: Bool {
        self != .traceroute
    }

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

    var summary: String {
        switch self {
        case .ping:
            return "Measure TCP reachability and latency"
        case .dns:
            return "Query A, MX, and TXT records"
        case .whois:
            return "Look up domain registration data"
        case .traceroute:
            return "Trace the network path to a host"
        case .portScan:
            return "Find reachable TCP services"
        case .ipCalculator:
            return "Calculate IPv4 subnet details"
        }
    }
    
    var showsDNSRecordPicker: Bool {
        self == .dns
    }
    
    var requiresSubnetMask: Bool {
        self == .ipCalculator
    }
    
    var shouldForceLowercase: Bool {
        switch self {
        case .dns, .whois:
            return true
        default:
            return false
        }
    }
    
    var requiresPortRange: Bool {
        self == .portScan
    }

    var prefersNumericKeyboard: Bool {
        self == .ipCalculator || self == .portScan
    }
}

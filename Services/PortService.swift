//
//  PortService.swift
//  NetInspector
//
//  Created by Esra Yaman on 20.07.2026.
//

import Foundation

struct PortService {

    func serviceName(for port: Int) -> String {

        switch port {

        case 20, 21:
            return "FTP"

        case 22:
            return "SSH"

        case 23:
            return "Telnet"

        case 25:
            return "SMTP"

        case 53:
            return "DNS"

        case 80:
            return "HTTP"

        case 110:
            return "POP3"

        case 143:
            return "IMAP"

        case 443:
            return "HTTPS"

        case 3306:
            return "MySQL"

        case 5432:
            return "PostgreSQL"

        case 6379:
            return "Redis"

        case 8080:
            return "HTTP Alt"

        default:
            return "Unknown"

        }

    }

}

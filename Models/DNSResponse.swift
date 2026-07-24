//
//  DNSResponse.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import Foundation

struct DNSResponse: Codable {

    let Status: Int
    let Answer: [DNSAnswer]?

}

struct DNSAnswer: Codable {

    let name: String
    let type: Int
    let TTL: Int
    let data: String

}

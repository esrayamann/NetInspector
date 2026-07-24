//
//  PortScanResult.swift
//  NetInspector
//
//  Created by Esra Yaman on 20.07.2026.
//

import Foundation

struct PortScanResult: Identifiable {

    let id = UUID()
    let port: Int
    let service: String

}

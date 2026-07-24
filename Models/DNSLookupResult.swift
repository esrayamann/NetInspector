//
//  DNSLookupResult.swift
//  NetInspector
//
//  Created by Esra Yaman on 23.07.2026.
//

import Foundation

struct DNSLookupResult {

    let domain: String
    let recordType: DNSRecordType
    let records: [String]

}

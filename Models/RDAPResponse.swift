//
//  RDAPResponse.swift
//  NetInspector
//
//  Created by Esra Yaman on 20.07.2026.
//

import Foundation

struct RDAPResponse: Codable {

    let ldhName: String?
   // let entities: [RDAPEntity]?
    let events: [RDAPEvent]?
    let nameservers: [RDAPNameserver]?

}

struct RDAPEvent: Codable {

    let eventAction: String
    let eventDate: String

}

struct RDAPNameserver: Codable {

    let ldhName: String?

}

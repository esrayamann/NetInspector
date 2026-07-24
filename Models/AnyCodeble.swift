//
//  AnyCodeble.swift
//  NetInspector
//
//  Created by Esra Yaman on 20.07.2026.
//

import Foundation

struct AnyCodable: Codable {

    let value: Any

    init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()

        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else {
            value = ""
        }
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.singleValueContainer()

        switch value {

        case let string as String:
            try container.encode(string)

        case let int as Int:
            try container.encode(int)

        case let double as Double:
            try container.encode(double)

        case let bool as Bool:
            try container.encode(bool)

        default:
            try container.encodeNil()

        }

    }

}

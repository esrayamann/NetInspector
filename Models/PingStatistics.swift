//
//  PingStatistics.swift
//  NetInspector
//
//  Created by Esra Yaman on 23.07.2026.
//

struct PingStatistics {

    let host: String
    let ip: String

    let values: [Double]

    var minimum: Double {
        values.min() ?? 0
    }

    var maximum: Double {
        values.max() ?? 0
    }

    var average: Double {
        values.reduce(0, +) / Double(values.count)
    }

}

//
//  Array+Chunk.swift
//  NetInspector
//
//  Created by Esra Yaman on 20.07.2026.
//

import Foundation

extension Array {

    func chunked(into size: Int) -> [[Element]] {

        stride(
            from: 0,
            to: count,
            by: size
        ).map {

            Array(self[$0..<Swift.min($0 + size, count)])

        }

    }

}

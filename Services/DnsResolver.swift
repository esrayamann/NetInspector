//
//  DnsResolver.swift
//  NetInspector
//
//  Created by Esra Yaman on 23.07.2026.
//

import Foundation

enum DnsResolver {

    static func resolve(_ host: String) async throws -> [String] {

        try await withCheckedThrowingContinuation { continuation in

            DispatchQueue.global().async {

                var hints = addrinfo(
                    ai_flags: AI_ADDRCONFIG,
                    ai_family: AF_INET,
                    ai_socktype: SOCK_STREAM,
                    ai_protocol: IPPROTO_TCP,
                    ai_addrlen: 0,
                    ai_canonname: nil,
                    ai_addr: nil,
                    ai_next: nil
                )

                var result: UnsafeMutablePointer<addrinfo>?

                let error = getaddrinfo(
                    host,
                    nil,
                    &hints,
                    &result
                )

                guard error == 0, let first = result else {

                    continuation.resume(
                        throwing: URLError(.cannotFindHost)
                    )
                    return

                }

                defer {
                    freeaddrinfo(first)
                }

                var ips: [String] = []

                var pointer: UnsafeMutablePointer<addrinfo>? = first

                while let info = pointer {

                    var address = info.pointee.ai_addr.pointee

                    var hostBuffer = [CChar](
                        repeating: 0,
                        count: Int(NI_MAXHOST)
                    )

                    getnameinfo(
                        &address,
                        socklen_t(info.pointee.ai_addrlen),
                        &hostBuffer,
                        socklen_t(hostBuffer.count),
                        nil,
                        0,
                        NI_NUMERICHOST
                    )

                    let bytes = hostBuffer.prefix { $0 != 0 }
                    ips.append(String(decoding: bytes.map(UInt8.init), as: UTF8.self))

                    pointer = info.pointee.ai_next
                }

                continuation.resume(returning: ips)

            }

        }

    }

}
